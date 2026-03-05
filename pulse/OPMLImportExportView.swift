//
//  OPMLImportExportView.swift
//  pulse
//
//  Created by Matthieu Rocher on 05/03/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct OPMLImportExportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var feeds: [RSSFeed]
    
    @State private var showingFileImporter = false
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    
    @State private var isImporting = false
    @State private var isExporting = false
    
    @State private var importResult: ImportResult?
    @State private var showingImportResult = false
    
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                            .glassEffect(.regular.tint(.blue), in: .circle)
                        
                        Text("OPML Import/Export", bundle: .main, comment: "OPML screen title")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Backup or restore your RSS feeds", bundle: .main, comment: "OPML screen subtitle")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    
                    // Export Section
                    VStack(alignment: .leading, spacing: 16) {
                        Label(String(localized: "Export Feeds", comment: "Export section title"), 
                              systemImage: "square.and.arrow.up")
                            .font(.headline)
                        
                        Text("Export all your feeds to an OPML file", bundle: .main, comment: "Export description")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if feeds.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.orange)
                                Text("No feeds to export", bundle: .main, comment: "No feeds message")
                                    .font(.subheadline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .glassEffect(.regular.tint(.orange), in: .rect(cornerRadius: 12))
                        } else {
                            Button {
                                exportFeeds()
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title3)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Export \(feeds.count) feeds", bundle: .main, comment: "Export button")
                                            .font(.headline)
                                        Text("Save to file or share", bundle: .main, comment: "Export subtitle")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    if isExporting {
                                        ProgressView()
                                    } else {
                                        Image(systemName: "chevron.right")
                                            .font(.title3)
                                    }
                                }
                                .padding(16)
                                .glassEffect(.regular.tint(.blue).interactive(), in: .rect(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                            .disabled(isExporting)
                        }
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    
                    // Import Section
                    VStack(alignment: .leading, spacing: 16) {
                        Label(String(localized: "Import Feeds", comment: "Import section title"), 
                              systemImage: "square.and.arrow.down")
                            .font(.headline)
                        
                        Text("Import feeds from an OPML file", bundle: .main, comment: "Import description")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button {
                            showingFileImporter = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title3)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Choose OPML File", bundle: .main, comment: "Import button")
                                        .font(.headline)
                                    Text("Select file from device", bundle: .main, comment: "Import subtitle")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer(minLength: 0)
                                
                                if isImporting {
                                    ProgressView()
                                } else {
                                    Image(systemName: "chevron.right")
                                        .font(.title3)
                                }
                            }
                            .padding(16)
                            .glassEffect(.regular.tint(.green).interactive(), in: .rect(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                        .disabled(isImporting)
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    
                    // Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label(String(localized: "About OPML", comment: "Info section title"), 
                              systemImage: "info.circle")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            InfoRow(
                                icon: "doc.text",
                                title: String(localized: "Standard Format", comment: "OPML info"),
                                description: String(localized: "OPML is the standard format for RSS feed lists", comment: "OPML description")
                            )
                            
                            InfoRow(
                                icon: "arrow.triangle.2.circlepath",
                                title: String(localized: "Portable", comment: "OPML info"),
                                description: String(localized: "Transfer feeds between different RSS readers", comment: "OPML description")
                            )
                            
                            InfoRow(
                                icon: "shield.checkered",
                                title: String(localized: "Safe", comment: "OPML info"),
                                description: String(localized: "Only feed URLs are exported, no personal data", comment: "OPML description")
                            )
                        }
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                }
                .padding()
            }
            .navigationTitle(String(localized: "OPML", comment: "OPML navigation title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Done", comment: "Done button")) {
                        dismiss()
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: [.xml, .opml],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
            .sheet(item: $exportURL) { url in
                ShareSheet(items: [url])
            }
            .alert(String(localized: "Import Complete", comment: "Import alert title"), 
                   isPresented: $showingImportResult,
                   presenting: importResult) { result in
                Button(String(localized: "OK", comment: "OK button")) {
                    if result.hasSuccess {
                        dismiss()
                    }
                }
            } message: { result in
                Text(result.message)
            }
            .alert(String(localized: "Error", comment: "Error alert title"), 
                   isPresented: $showingError,
                   presenting: errorMessage) { _ in
                Button(String(localized: "OK", comment: "OK button")) { }
            } message: { message in
                Text(message)
            }
        }
    }
    
    // MARK: - Export
    
    private func exportFeeds() {
        Task {
            isExporting = true
            defer { isExporting = false }
            
            do {
                let manager = OPMLManager(modelContext: modelContext)
                let url = try manager.exportToFile(feeds)
                exportURL = url
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    // MARK: - Import
    
    private func handleFileImport(_ result: Result<[URL], Error>) {
        Task {
            isImporting = true
            defer { isImporting = false }
            
            do {
                let urls = try result.get()
                guard let url = urls.first else { return }
                
                let manager = OPMLManager(modelContext: modelContext)
                let result = try await manager.importFeeds(from: url)
                
                importResult = result
                showingImportResult = true
                
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - URL Identifiable Extension

extension URL: Identifiable {
    public var id: String { absoluteString }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSFeed.self, configurations: config)
    
    let feed1 = RSSFeed(title: "Apple Newsroom", urlString: "https://www.apple.com/newsroom/rss-feed.rss")
    let feed2 = RSSFeed(title: "Swift.org Blog", urlString: "https://www.swift.org/blog/rss.xml")
    
    container.mainContext.insert(feed1)
    container.mainContext.insert(feed2)
    
    return OPMLImportExportView()
        .modelContainer(container)
}
