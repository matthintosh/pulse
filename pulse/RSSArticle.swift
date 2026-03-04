//
//  RSSArticle.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import Foundation
import SwiftData

@Model
final class RSSArticle {
    var id: UUID
    var title: String
    var articleDescription: String
    var content: String
    var contentHTML: String? // Store raw HTML content for image extraction
    var link: String
    var imageURL: String?
    var publishDate: Date
    var isRead: Bool
    
    var feed: RSSFeed?
    
    init(title: String, articleDescription: String, content: String, contentHTML: String? = nil, link: String, imageURL: String? = nil, publishDate: Date) {
        self.id = UUID()
        self.title = title
        self.articleDescription = articleDescription
        self.content = content
        self.contentHTML = contentHTML
        self.link = link
        self.imageURL = imageURL
        self.publishDate = publishDate
        self.isRead = false
    }
    
    /// Extracts the first image URL from HTML content
    var firstImageURL: String? {
        if let imageURL = imageURL, !imageURL.isEmpty {
            return imageURL
        }
        
        guard let html = contentHTML, !html.isEmpty else { return nil }
        
        // Try to match <img> tags with src attribute (supports both double and single quotes)
        let patterns = [
            "<img[^>]+src=\"([^\"]+)\"",  // src="..."
            "<img[^>]+src='([^']+)'",     // src='...'
            "<img[^>]+src=([^\\s>]+)"     // src=... (no quotes)
        ]
        
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
                continue
            }
            
            let range = NSRange(html.startIndex..., in: html)
            if let match = regex.firstMatch(in: html, options: [], range: range),
               let srcRange = Range(match.range(at: 1), in: html) {
                let urlString = String(html[srcRange])
                // Make sure it's a valid URL
                if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
                    return urlString
                }
            }
        }
        
        return nil
    }
}
