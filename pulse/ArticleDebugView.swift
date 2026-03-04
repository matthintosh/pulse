//
//  ArticleDebugView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SwiftData

struct ArticleDebugView: View {
    let article: RSSArticle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("Debug Info for: \(article.title)")
                        .font(.headline)
                    
                    Divider()
                    
                    Text("imageURL:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(article.imageURL ?? "nil")
                        .font(.caption2)
                        .textSelection(.enabled)
                    
                    Divider()
                    
                    Text("contentHTML:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(article.contentHTML ?? "nil")
                        .font(.caption2)
                        .textSelection(.enabled)
                    
                    Divider()
                    
                    Text("firstImageURL:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(article.firstImageURL ?? "nil")
                        .font(.caption2)
                        .textSelection(.enabled)
                    
                    Divider()
                    
                    Text("content (stripped):")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(article.content)
                        .font(.caption2)
                        .textSelection(.enabled)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSArticle.self, RSSFeed.self, configurations: config)
    let context = container.mainContext
    
    let feed = RSSFeed(title: "Example Feed", urlString: "https://example.com")
    
    let htmlContent = """
    <p>This is an example article with an image.</p>
    <img src="https://picsum.photos/800/600" alt="Sample image" />
    <p>Lorem ipsum dolor sit amet.</p>
    """
    
    let article = RSSArticle(
        title: "Test Article",
        articleDescription: "Test description",
        content: "Test content",
        contentHTML: htmlContent,
        link: "https://example.com/article",
        imageURL: nil,
        publishDate: Date()
    )
    article.feed = feed
    
    context.insert(feed)
    context.insert(article)
    
    return ArticleDebugView(article: article)
        .modelContainer(container)
}
