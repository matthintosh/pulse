//
//  RSSParser.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentContent = ""
    private var currentLink = ""
    private var currentImageURL = ""
    private var currentEnclosureURLs: [String] = []
    private var currentPubDate = ""
    
    private var parsingItem = false
    private var articles: [ParsedArticle] = []
    
    struct ParsedArticle {
        let title: String
        let description: String
        let content: String
        let contentHTML: String?
        let link: String
        let imageURL: String?
        let enclosureURLs: [String]?
        let publishDate: Date
    }
    
    func parse(data: Data) async throws -> [ParsedArticle] {
        return try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: data)
            parser.delegate = self
            
            if parser.parse() {
                continuation.resume(returning: articles)
            } else {
                continuation.resume(throwing: NSError(domain: "RSSParser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse RSS feed"]))
            }
        }
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            parsingItem = true
            currentTitle = ""
            currentDescription = ""
            currentContent = ""
            currentLink = ""
            currentImageURL = ""
            currentEnclosureURLs = []
            currentPubDate = ""
        }
        
        // Handle media:content, enclosure, or media:thumbnail for images
        if parsingItem {
            if elementName == "media:content" || elementName == "media:thumbnail" {
                if let url = attributeDict["url"] {
                    // Check if it's an image by URL or mime type
                    let isImage = url.contains("image") ||
                                  url.hasSuffix(".jpg") ||
                                  url.hasSuffix(".jpeg") ||
                                  url.hasSuffix(".png") ||
                                  url.hasSuffix(".gif") ||
                                  url.hasSuffix(".webp") ||
                                  attributeDict["medium"] == "image" ||
                                  attributeDict["type"]?.contains("image") == true
                    
                    if isImage {
                        // Add to enclosures
                        currentEnclosureURLs.append(url)
                        
                        // Set as main image if we don't have one yet
                        if currentImageURL.isEmpty {
                            currentImageURL = url
                        }
                    }
                }
            } else if elementName == "enclosure" {
                if let url = attributeDict["url"] {
                    let type = attributeDict["type"] ?? ""
                    
                    // Add all enclosures
                    currentEnclosureURLs.append(url)
                    
                    // If it's an image and we don't have one yet, set as main image
                    if type.contains("image") && currentImageURL.isEmpty {
                        currentImageURL = url
                    }
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        if parsingItem {
            switch currentElement {
            case "title":
                currentTitle += trimmed
            case "description":
                currentDescription += trimmed
            case "content:encoded", "content":
                currentContent += trimmed
            case "link":
                currentLink += trimmed
            case "pubDate":
                currentPubDate += trimmed
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            parsingItem = false
            
            let publishDate = parseDate(from: currentPubDate) ?? Date()
            let description = currentDescription.isEmpty ? String(currentContent.prefix(200)) : currentDescription
            let content = currentContent.isEmpty ? currentDescription : currentContent
            
            let article = ParsedArticle(
                title: currentTitle,
                description: stripHTML(description),
                content: stripHTML(content),
                contentHTML: content.isEmpty ? nil : content, // Store raw HTML
                link: currentLink,
                imageURL: currentImageURL.isEmpty ? nil : currentImageURL,
                enclosureURLs: currentEnclosureURLs.isEmpty ? nil : currentEnclosureURLs,
                publishDate: publishDate
            )
            
            articles.append(article)
        }
    }
    
    // MARK: - Helper Methods
    
    private func parseDate(from string: String) -> Date? {
        // Try RFC 822 format (RSS 2.0)
        let rfc822Formatter = DateFormatter()
        rfc822Formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        rfc822Formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = rfc822Formatter.date(from: string) {
            return date
        }
        
        // Try ISO 8601 format (Atom)
        let iso8601Formatter = ISO8601DateFormatter()
        if let date = iso8601Formatter.date(from: string) {
            return date
        }
        
        // Try alternative RFC 822 format without timezone
        let altFormatter = DateFormatter()
        altFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        altFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = altFormatter.date(from: string) {
            return date
        }
        
        return nil
    }
    
    private func stripHTML(_ string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
