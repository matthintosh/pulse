//
//  RSSService.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import Foundation
import SwiftData

@MainActor
class RSSService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchFeed(_ feed: RSSFeed) async throws {
        guard let url = URL(string: feed.urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let parser = RSSParser()
        let parsedArticles = try await parser.parse(data: data)
        
        // Clear existing articles for this feed
        if let existingArticles = feed.articles {
            for article in existingArticles {
                modelContext.delete(article)
            }
        }
        
        // Add new articles
        for parsed in parsedArticles {
            let article = RSSArticle(
                title: parsed.title,
                articleDescription: parsed.description,
                content: parsed.content,
                contentHTML: parsed.contentHTML,
                link: parsed.link,
                imageURL: parsed.imageURL,
                enclosureURLs: parsed.enclosureURLs,
                publishDate: parsed.publishDate
            )
            article.feed = feed
            modelContext.insert(article)
        }
        
        feed.lastUpdated = Date()
        try modelContext.save()
    }
    
    func refreshAllFeeds(feeds: [RSSFeed]) async {
        await withTaskGroup(of: Void.self) { group in
            for feed in feeds {
                group.addTask {
                    try? await self.fetchFeed(feed)
                }
            }
        }
    }
}
