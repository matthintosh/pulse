//
//  ArticleCardView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SwiftData

struct ArticleCardView: View {
    let article: RSSArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image - try imageURL first, then extract from HTML
            if let imageURLString = article.firstImageURL, let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay {
                                ProgressView()
                            }
                    case .success(let image):
                        GeometryReader { geometry in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 200)
                                .clipped()
                        }
                        .frame(height: 200)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                // Placeholder when no image
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                    .overlay {
                        Image(systemName: "newspaper")
                            .font(.system(size: 50))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Description
                Text(article.articleDescription)
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Metadata
                HStack(spacing: 8) {
                    if !article.isRead {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                    }
                    
                    Text(article.publishDate, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    if let feedTitle = article.feed?.title {
                        Text(feedTitle)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(16)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSArticle.self, RSSFeed.self, configurations: config)
    let context = container.mainContext
    
    let feed = RSSFeed(title: "Example Feed", urlString: "https://example.com")
    
    // Create article with HTML content containing an image
    let htmlContent = """
    <p>This is an example article with an image.</p>
    <img src="https://picsum.photos/800/600" alt="Sample image" />
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
    """
    
    let article = RSSArticle(
        title: "Amazing SwiftUI Features You Should Know",
        articleDescription: "Discover the latest and greatest features in SwiftUI that will transform your app development experience.",
        content: "Full article content here...",
        contentHTML: htmlContent,
        link: "https://example.com/article",
        imageURL: nil,
        publishDate: Date()
    )
    article.feed = feed
    
    context.insert(feed)
    context.insert(article)
    
    return ArticleCardView(article: article)
        .padding()
        .modelContainer(container)
}
