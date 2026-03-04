//
//  RSSFeed.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import Foundation
import SwiftData

@Model
final class RSSFeed {
    var id: UUID
    var title: String
    var urlString: String
    var lastUpdated: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \RSSArticle.feed)
    var articles: [RSSArticle]?
    
    init(title: String, urlString: String) {
        self.id = UUID()
        self.title = title
        self.urlString = urlString
        self.lastUpdated = nil
        self.articles = []
    }
}
