//
//  ContentView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RSSArticle.publishDate, order: .reverse) private var articles: [RSSArticle]
    @Query private var feeds: [RSSFeed]
    
    @State private var showingFeedManagement = false
    @State private var isRefreshing = false
    @State private var searchText = ""
    @State private var selectedFeed: RSSFeed?
    @State private var showUnreadOnly = false
    
    var filteredArticles: [RSSArticle] {
        var result = articles
        
        // Filter by selected feed
        if let selectedFeed = selectedFeed {
            result = result.filter { $0.feed?.id == selectedFeed.id }
        }
        
        // Filter by unread
        if showUnreadOnly {
            result = result.filter { !$0.isRead }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            result = result.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.articleDescription.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if feeds.isEmpty {
                    emptyStateView
                } else {
                    articleListView
                }
            }
            .navigationTitle("Pulse")
            .searchable(text: $searchText, prompt: Text("Search articles", bundle: .main, comment: "Search prompt"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            selectedFeed = nil
                        } label: {
                            Label(String(localized: "All Feeds", comment: "Filter option for all feeds"), systemImage: selectedFeed == nil ? "checkmark" : "")
                        }
                        
                        Divider()
                        
                        ForEach(feeds) { feed in
                            Button {
                                selectedFeed = feed
                            } label: {
                                Label(feed.title, systemImage: selectedFeed?.id == feed.id ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showUnreadOnly.toggle()
                    } label: {
                        Image(systemName: showUnreadOnly ? "envelope.badge.fill" : "envelope.open")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task {
                            await refreshFeedsAsync()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isRefreshing)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingFeedManagement = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingFeedManagement) {
                FeedManagementView()
            }
        }
    }
    
    private var articleListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if filteredArticles.isEmpty {
                    noArticlesView
                } else {
                    ForEach(filteredArticles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            ArticleCardView(article: article)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .refreshable {
            await refreshFeedsAsync()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "newspaper.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .glassEffect(.regular.tint(.blue), in: .circle)
            
            VStack(spacing: 12) {
                Text("Welcome to Pulse", bundle: .main, comment: "Welcome title")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your beautiful RSS reader with\nLiquid Glass design", bundle: .main, comment: "Welcome subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                showingFeedManagement = true
            } label: {
                Label(String(localized: "Add Your First Feed", comment: "Button to add first feed"), systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Get started with popular feeds:", bundle: .main, comment: "Popular feeds section header")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button {
                    addSampleFeeds()
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Add Sample Feeds", bundle: .main, comment: "Button to add sample feeds")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(40)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
        .padding()
    }
    
    private var noArticlesView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            
            Text(searchText.isEmpty ? String(localized: "No articles yet", comment: "No articles message") : String(localized: "No matching articles", comment: "No search results message"))
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(searchText.isEmpty ? String(localized: "Pull to refresh your feeds", comment: "Refresh instruction") : String(localized: "Try a different search term", comment: "Search suggestion"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
    
    @MainActor
    private func refreshFeedsAsync() async {
        guard !feeds.isEmpty else { return }
        
        isRefreshing = true
        
        let service = RSSService(modelContext: modelContext)
        await service.refreshAllFeeds(feeds: feeds)
        
        isRefreshing = false
    }
    
    private func addSampleFeeds() {
        let sampleFeeds = [
            RSSFeed(title: "Apple Newsroom", urlString: "https://www.apple.com/newsroom/rss-feed.rss"),
            RSSFeed(title: "Swift.org Blog", urlString: "https://www.swift.org/blog/rss.xml")
        ]
        
        for feed in sampleFeeds {
            modelContext.insert(feed)
        }
        
        try? modelContext.save()
        
        Task {
            await refreshFeedsAsync()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSArticle.self, RSSFeed.self, configurations: config)
    
    // Add sample data
    let feed = RSSFeed(title: "Example Feed", urlString: "https://example.com")
    
    let article1 = RSSArticle(
        title: "Amazing SwiftUI Features",
        articleDescription: "Discover the latest features in SwiftUI that will transform your development.",
        content: "Full content here...",
        link: "https://example.com/1",
        imageURL: nil,
        publishDate: Date()
    )
    article1.feed = feed
    
    let article2 = RSSArticle(
        title: "Building Great Apps",
        articleDescription: "Learn how to build amazing apps with modern tools and techniques.",
        content: "Full content here...",
        link: "https://example.com/2",
        imageURL: nil,
        publishDate: Date().addingTimeInterval(-3600)
    )
    article2.feed = feed
    article2.isRead = true
    
    container.mainContext.insert(feed)
    container.mainContext.insert(article1)
    container.mainContext.insert(article2)
    
    return ContentView()
        .modelContainer(container)
}
