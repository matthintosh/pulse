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
            .navigationTitle("Manage Feeds")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddFeed = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glass)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        refreshAllFeeds()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(.glass)
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
            
            Text("No RSS Feeds")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first RSS feed to get started")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddFeed = true
            } label: {
                Label("Add Feed", systemImage: "plus")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.glassProminent)
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
                    Text("Updated \(lastUpdated, style: .relative) ago")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer()
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.body)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.glass)
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
