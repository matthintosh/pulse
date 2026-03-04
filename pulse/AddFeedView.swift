//
//  AddFeedView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SwiftData

struct AddFeedView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var feedTitle = ""
    @State private var feedURL = ""
    @State private var isValidating = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "newspaper.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                            .glassEffect(.regular.tint(.blue), in: .circle)
                        
                        Text("Add RSS Feed")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Enter the feed name and RSS URL")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    
                    // Form
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Feed Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("e.g., Apple News", text: $feedTitle)
                                .textFieldStyle(.plain)
                                .padding(12)
                                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("RSS URL")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("https://example.com/feed.xml", text: $feedURL)
                                .textFieldStyle(.plain)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                                .autocorrectionDisabled()
                                .padding(12)
                                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                        }
                        
                        if let errorMessage = errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.red)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .glassEffect(.regular.tint(.red), in: .rect(cornerRadius: 12))
                        }
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    
                    // Popular Feeds Suggestions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Feeds")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(popularFeeds) { suggestion in
                                Button {
                                    feedTitle = suggestion.name
                                    feedURL = suggestion.url
                                } label: {
                                    HStack {
                                        Image(systemName: suggestion.icon)
                                            .foregroundStyle(.blue)
                                            .frame(width: 30)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(suggestion.name)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text(suggestion.url)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                }
                .padding()
            }
            .navigationTitle("Add Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addFeed()
                    } label: {
                        if isValidating {
                            ProgressView()
                        } else {
                            Text("Add")
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(feedTitle.isEmpty || feedURL.isEmpty || isValidating)
                }
            }
        }
    }
    
    private let popularFeeds = [
        FeedSuggestion(name: "Apple Newsroom", url: "https://www.apple.com/newsroom/rss-feed.rss", icon: "applelogo"),
        FeedSuggestion(name: "Swift.org Blog", url: "https://www.swift.org/blog/rss.xml", icon: "swift"),
        FeedSuggestion(name: "Hacker News", url: "https://news.ycombinator.com/rss", icon: "terminal"),
        FeedSuggestion(name: "TechCrunch", url: "https://techcrunch.com/feed/", icon: "newspaper")
    ]
    
    private func addFeed() {
        Task {
            isValidating = true
            errorMessage = nil
            defer { isValidating = false }
            
            let feed = RSSFeed(title: feedTitle, urlString: feedURL)
            modelContext.insert(feed)
            
            let service = RSSService(modelContext: modelContext)
            
            do {
                try await service.fetchFeed(feed)
                dismiss()
            } catch {
                errorMessage = "Failed to load feed. Please check the URL and try again."
                modelContext.delete(feed)
            }
        }
    }
}

struct FeedSuggestion: Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let icon: String
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSFeed.self, configurations: config)
    
    return AddFeedView()
        .modelContainer(container)
}
