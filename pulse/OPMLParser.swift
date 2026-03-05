//
//  OPMLParser.swift
//  pulse
//
//  Created by Matthieu Rocher on 05/03/2026.
//

import Foundation

/// OPML Feed representation
struct OPMLFeed {
    let title: String
    let xmlUrl: String
    let htmlUrl: String?
    let description: String?
    
    init(title: String, xmlUrl: String, htmlUrl: String? = nil, description: String? = nil) {
        self.title = title
        self.xmlUrl = xmlUrl
        self.htmlUrl = htmlUrl
        self.description = description
    }
}

/// Parser for OPML files (Outline Processor Markup Language)
/// Standard format for RSS feed subscription lists
class OPMLParser: NSObject, XMLParserDelegate {
    private var feeds: [OPMLFeed] = []
    private var currentElement = ""
    private var currentAttributes: [String: String] = [:]
    
    // MARK: - Parsing
    
    /// Parse OPML data and return array of feeds
    func parse(data: Data) throws -> [OPMLFeed] {
        feeds = []
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        guard parser.parse() else {
            throw OPMLError.parsingFailed
        }
        
        return feeds
    }
    
    /// Parse OPML from URL
    func parse(url: URL) throws -> [OPMLFeed] {
        let data = try Data(contentsOf: url)
        return try parse(data: data)
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, 
                didStartElement elementName: String, 
                namespaceURI: String?, 
                qualifiedName qName: String?, 
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentAttributes = attributeDict
        
        // OPML feed entries are in <outline> elements with type="rss"
        if elementName == "outline" {
            // Check if this is an RSS feed outline
            let type = attributeDict["type"]?.lowercased()
            let xmlUrl = attributeDict["xmlUrl"]
            
            // Only process RSS/feed outlines with xmlUrl
            if (type == "rss" || type == "feed" || xmlUrl != nil),
               let feedUrl = xmlUrl,
               !feedUrl.isEmpty {
                
                let title = attributeDict["text"] ?? attributeDict["title"] ?? "Untitled Feed"
                let htmlUrl = attributeDict["htmlUrl"]
                let description = attributeDict["description"]
                
                let feed = OPMLFeed(
                    title: title,
                    xmlUrl: feedUrl,
                    htmlUrl: htmlUrl,
                    description: description
                )
                
                feeds.append(feed)
            }
        }
    }
    
    // MARK: - Generation
    
    /// Generate OPML XML from array of feeds
    static func generate(feeds: [RSSFeed], title: String = "RSS Feeds") -> String {
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: Date())
        
        var opml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <head>
                <title>\(title.xmlEscaped)</title>
                <dateCreated>\(dateString)</dateCreated>
                <docs>http://www.opml.org/spec2</docs>
            </head>
            <body>
        
        """
        
        for feed in feeds {
            let title = feed.title.xmlEscaped
            let xmlUrl = feed.urlString.xmlEscaped
            
            opml += "        <outline type=\"rss\" text=\"\(title)\" xmlUrl=\"\(xmlUrl)\" />\n"
        }
        
        opml += """
            </body>
        </opml>
        """
        
        return opml
    }
}

// MARK: - Error Types

enum OPMLError: LocalizedError {
    case parsingFailed
    case invalidFormat
    case noFeedsFound
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .parsingFailed:
            return String(localized: "Failed to parse OPML file", comment: "OPML parsing error")
        case .invalidFormat:
            return String(localized: "Invalid OPML format", comment: "OPML format error")
        case .noFeedsFound:
            return String(localized: "No feeds found in OPML file", comment: "No feeds error")
        case .fileNotFound:
            return String(localized: "OPML file not found", comment: "File not found error")
        }
    }
}

// MARK: - String Extension for XML Escaping

extension String {
    /// Escape string for XML
    var xmlEscaped: String {
        var result = self
        result = result.replacingOccurrences(of: "&", with: "&amp;")
        result = result.replacingOccurrences(of: "<", with: "&lt;")
        result = result.replacingOccurrences(of: ">", with: "&gt;")
        result = result.replacingOccurrences(of: "\"", with: "&quot;")
        result = result.replacingOccurrences(of: "'", with: "&apos;")
        return result
    }
}
