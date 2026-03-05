//
//  FeedManagementView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SwiftData

struct FeedManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var feeds: [RSSFeed]
    
    @State private var showingAddFeed = false
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GlassEffectContainer(spacing: 20) {
                    VStack(spacing: 16) {
                        if feeds.isEmpty {
                            emptyStateView
                        } else {
                            ForEach(feeds) { feed in
                                FeedRowView(feed: feed, onDelete: {
                                    deleteFeed(feed)
                                })
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(String(localized: "Manage Feeds", comment: "Feed management title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Done", comment: "Done button")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddFeed = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        refreshAllFeeds()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isRefreshing)
                }
            }
            .sheet(isPresented: $showingAddFeed) {
                AddFeedView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "newspaper.circle")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)
            
            Text("No RSS Feeds", bundle: .main, comment: "No feeds message")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first RSS feed to get started", bundle: .main, comment: "Add first feed instruction")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddFeed = true
            } label: {
                Label(String(localized: "Add Feed", comment: "Add feed button"), systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
    
    private func deleteFeed(_ feed: RSSFeed) {
        withAnimation {
            modelContext.delete(feed)
            try? modelContext.save()
        }
    }
    
    private func refreshAllFeeds() {
        Task {
            isRefreshing = true
            defer { isRefreshing = false }
            
            let service = RSSService(modelContext: modelContext)
            await service.refreshAllFeeds(feeds: feeds)
        }
    }
}

struct FeedRowView: View {
    let feed: RSSFeed
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .glassEffect(.regular.tint(.blue), in: .circle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feed.title)
                    .font(.headline)
                
                Text(feed.urlString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                if let lastUpdated = feed.lastUpdated {
                    Text("Updated \(lastUpdated, style: .relative) ago", bundle: .main, comment: "Last update time")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer()
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
            }
        }
        .padding(16)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSFeed.self, configurations: config)
    
    let feed1 = RSSFeed(title: "Apple Developer News", urlString: "https://developer.apple.com/news/rss/news.rss")
    let feed2 = RSSFeed(title: "Swift Blog", urlString: "https://www.swift.org/blog/rss.xml")
    
    container.mainContext.insert(feed1)
    container.mainContext.insert(feed2)
    
    return FeedManagementView()
        .modelContainer(container)
}
