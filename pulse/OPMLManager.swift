//
//  OPMLManager.swift
//  pulse
//
//  Created by Matthieu Rocher on 05/03/2026.
//

import Foundation
import SwiftData
import UniformTypeIdentifiers

/// Manager for OPML import and export operations
@MainActor
class OPMLManager {
    private let modelContext: ModelContext
    private let rssService: RSSService
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.rssService = RSSService(modelContext: modelContext)
    }
    
    // MARK: - Export
    
    /// Export all feeds to OPML format
    func exportFeeds(_ feeds: [RSSFeed]) -> String {
        let appName = "Pulse RSS Reader"
        return OPMLParser.generate(feeds: feeds, title: appName)
    }
    
    /// Export feeds to a file URL
    func exportToFile(_ feeds: [RSSFeed]) throws -> URL {
        let opmlString = exportFeeds(feeds)
        
        // Create temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let filename = "pulse-feeds-\(dateString).opml"
        let fileURL = tempDir.appendingPathComponent(filename)
        
        // Write to file
        try opmlString.write(to: fileURL, atomically: true, encoding: .utf8)
        
        return fileURL
    }
    
    // MARK: - Import
    
    /// Import feeds from OPML data
    func importFeeds(from data: Data) async throws -> ImportResult {
        let parser = OPMLParser()
        let opmlFeeds = try parser.parse(data: data)
        
        guard !opmlFeeds.isEmpty else {
            throw OPMLError.noFeedsFound
        }
        
        var imported = 0
        var skipped = 0
        var failed = 0
        
        // Get existing feed URLs to avoid duplicates
        let descriptor = FetchDescriptor<RSSFeed>()
        let existingFeeds = try modelContext.fetch(descriptor)
        let existingURLs = Set(existingFeeds.map { $0.urlString.lowercased() })
        
        for opmlFeed in opmlFeeds {
            // Skip if already exists
            if existingURLs.contains(opmlFeed.xmlUrl.lowercased()) {
                skipped += 1
                continue
            }
            
            // Create new feed
            let feed = RSSFeed(title: opmlFeed.title, urlString: opmlFeed.xmlUrl)
            modelContext.insert(feed)
            
            // Try to fetch articles
            do {
                try await rssService.fetchFeed(feed)
                imported += 1
            } catch {
                // Keep the feed even if fetching fails, user can retry later
                failed += 1
            }
        }
        
        // Save context
        try modelContext.save()
        
        return ImportResult(
            total: opmlFeeds.count,
            imported: imported,
            skipped: skipped,
            failed: failed
        )
    }
    
    /// Import feeds from OPML file URL
    func importFeeds(from url: URL) async throws -> ImportResult {
        // Start accessing security-scoped resource
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        let data = try Data(contentsOf: url)
        return try await importFeeds(from: data)
    }
}

// MARK: - Import Result

struct ImportResult {
    let total: Int
    let imported: Int
    let skipped: Int
    let failed: Int
    
    var message: String {
        var parts: [String] = []
        
        if imported > 0 {
            let importText = String(localized: "\(imported) feeds imported", comment: "Import success message")
            parts.append(importText)
        }
        
        if skipped > 0 {
            let skipText = String(localized: "\(skipped) already exist", comment: "Import skip message")
            parts.append(skipText)
        }
        
        if failed > 0 {
            let failText = String(localized: "\(failed) failed to load", comment: "Import fail message")
            parts.append(failText)
        }
        
        return parts.joined(separator: ", ")
    }
    
    var hasErrors: Bool {
        return failed > 0
    }
    
    var hasSuccess: Bool {
        return imported > 0
    }
}

// MARK: - UTType Extension for OPML

extension UTType {
    static let opml = UTType(exportedAs: "org.opml.opml", conformingTo: .xml)
}
