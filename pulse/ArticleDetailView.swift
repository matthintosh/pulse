//
//  ArticleDetailView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var article: RSSArticle
    @State private var showingWebView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image - Try imageURL first, then extract from HTML
                if let imageURLString = article.firstImageURL, let imageURL = URL(string: imageURLString) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 280)
                                .overlay {
                                    ProgressView()
                                }
                        case .success(let image):
                            GeometryReader { geometry in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 280)
                                    .clipped()
                            }
                            .frame(height: 280)
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 280)
                                .overlay {
                                    Image(systemName: "photo")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.tertiary)
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                // Article Header & Content
                VStack(alignment: .leading, spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 12) {
                        // Source & Date
                        HStack(spacing: 8) {
                            if let feedTitle = article.feed?.title {
                                Text(feedTitle)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.blue)
                                    .lineLimit(1)
                            }
                            
                            Text("•")
                                .foregroundStyle(.quaternary)
                            
                            Text(article.publishDate, format: .dateTime.day().month().year())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        
                        // Title
                        Text(article.title)
                            .font(.system(.title, design: .serif, weight: .bold))
                            .foregroundStyle(.primary)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Description/Summary
                        if !article.articleDescription.isEmpty {
                            Text(article.articleDescription)
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.top, article.firstImageURL != nil ? 24 : 0)
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    // Article Body
                    Text(article.content)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineSpacing(8)
                        .textSelection(.enabled)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Original Article Link
                    if let url = URL(string: article.link) {
                        Button {
                            showingWebView = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text")
                                    .font(.title3)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Read Full Article")
                                        .font(.headline)
                                    Text("Opens in Reader Mode")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.title3)
                            }
                            .padding(16)
                            .glassEffect(.regular.tint(.blue).interactive(), in: .rect(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 8)
                        .fullScreenCover(isPresented: $showingWebView) {
                            ArticleWebView(url: url)
                                .ignoresSafeArea()
                        }
                    }
                }
                .padding(24)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .padding(.horizontal)
                .padding(.top, article.firstImageURL != nil ? 20 : 0)
                .padding(.bottom)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 12) {
                    Button {
                        article.isRead.toggle()
                        try? modelContext.save()
                    } label: {
                        Label(
                            article.isRead ? "Mark as Unread" : "Mark as Read",
                            systemImage: article.isRead ? "checkmark.circle.fill" : "checkmark.circle"
                        )
                        .labelStyle(.iconOnly)
                    }
                    
                    ShareLink(item: URL(string: article.link)!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .onAppear {
            if !article.isRead {
                article.isRead = true
                try? modelContext.save()
            }
        }
    }
}

#Preview {
    @Previewable @Query var articles: [RSSArticle]
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSArticle.self, RSSFeed.self, configurations: config)
    let context = container.mainContext
    
    let feed = RSSFeed(title: "Tech News Daily", urlString: "https://example.com")
    
    // Create article with HTML content containing an image
    let htmlContent = """
    <p>This is an example article with an image.</p>
    <img src="https://picsum.photos/800/600" alt="Sample image" />
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
    """
    
    let longContent = """
    SwiftUI continues to evolve with each release, bringing powerful new features that make building apps easier and more intuitive than ever before.
    
    In this comprehensive guide, we'll explore the latest additions to SwiftUI that every developer should know about. From improved performance to new UI components, these features will transform how you build your apps.
    
    The Power of Declarative UI
    
    One of SwiftUI's greatest strengths is its declarative syntax. Instead of imperatively describing how to update the UI, you simply declare what the UI should look like for any given state. SwiftUI handles the rest, efficiently updating only the parts of the UI that need to change.
    
    This paradigm shift has made UI development not only faster but also more reliable. Bugs that used to plague imperative UI code—like forgetting to update a label or mismanaging view controller lifecycles—simply don't exist in SwiftUI.
    
    Performance Improvements
    
    Recent updates have brought significant performance improvements across the board. The rendering engine has been optimized, animations are smoother, and complex layouts render faster than ever before.
    
    These improvements mean your apps feel more responsive and polished, giving users a better experience without you having to write a single line of performance optimization code.
    
    Looking Forward
    
    As SwiftUI continues to mature, it's becoming clear that it represents the future of app development on Apple platforms. Whether you're building for iOS, iPadOS, macOS, watchOS, or visionOS, SwiftUI provides a unified, powerful way to create beautiful user interfaces.
    """
    
    let article = RSSArticle(
        title: "The Future of SwiftUI: New Features Every Developer Should Know",
        articleDescription: "Discover the latest and most powerful features in SwiftUI that will transform your app development workflow and help you build better apps faster.",
        content: longContent,
        contentHTML: htmlContent,
        link: "https://example.com/article",
        imageURL: nil,
        publishDate: Date()
    )
    article.feed = feed
    
    context.insert(feed)
    context.insert(article)
    
    return NavigationStack {
        ArticleDetailView(article: article)
    }
    .modelContainer(container)
}
