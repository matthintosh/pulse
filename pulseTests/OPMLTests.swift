//
//  OPMLTests.swift
//  pulseTests
//
//  Created by Matthieu Rocher on 05/03/2026.
//

import XCTest
import Foundation
@testable import pulse

// MARK: - OPML Parser Tests

final class OPMLParserTests: XCTestCase {
    
    // MARK: - Parsing Tests
    
    func testParseValidOPML() throws {
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <head>
                <title>Test Feeds</title>
            </head>
            <body>
                <outline type="rss" text="Feed 1" xmlUrl="https://example.com/feed1.xml" />
                <outline type="rss" text="Feed 2" xmlUrl="https://example.com/feed2.xml" htmlUrl="https://example.com" />
                <outline type="rss" text="Feed 3" xmlUrl="https://example.com/feed3.xml" description="Test feed" />
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        XCTAssertEqual(feeds.count, 3)
        XCTAssertEqual(feeds[0].title, "Feed 1")
        XCTAssertEqual(feeds[0].xmlUrl, "https://example.com/feed1.xml")
        XCTAssertEqual(feeds[1].htmlUrl, "https://example.com")
        XCTAssertEqual(feeds[2].description, "Test feed")
    }
    
    func testParseFeedType() throws {
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <body>
                <outline type="feed" text="Feed 1" xmlUrl="https://example.com/feed1.xml" />
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        XCTAssertEqual(feeds.count, 1)
    }
    
    func testParseNoTypeWithXmlUrl() throws {
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <body>
                <outline text="Feed 1" xmlUrl="https://example.com/feed1.xml" />
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        XCTAssertEqual(feeds.count, 1)
    }
    
    func testSkipNonFeedOutlines() throws {
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <body>
                <outline text="Category" />
                <outline type="rss" text="Feed 1" xmlUrl="https://example.com/feed1.xml" />
                <outline text="Another category" type="folder" />
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        // Should only parse the one with xmlUrl
        XCTAssertEqual(feeds.count, 1)
        XCTAssertEqual(feeds[0].title, "Feed 1")
    }
    
    func testParseEmptyOPML() throws {
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <body>
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        XCTAssertTrue(feeds.isEmpty)
    }
    
    func testUseTitleAsFallback() throws {
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <body>
                <outline type="rss" title="Feed Title" xmlUrl="https://example.com/feed.xml" />
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        XCTAssertEqual(feeds.count, 1)
        XCTAssertEqual(feeds[0].title, "Feed Title")
    }
    
    // MARK: - Generation Tests
    
    func testGenerateOPML() {
        let feeds = [
            RSSFeed(title: "Feed 1", urlString: "https://example.com/feed1.xml"),
            RSSFeed(title: "Feed 2", urlString: "https://example.com/feed2.xml"),
            RSSFeed(title: "Feed 3", urlString: "https://example.com/feed3.xml")
        ]
        
        let opml = OPMLParser.generate(feeds: feeds, title: "Test Export")
        
        XCTAssertTrue(opml.contains("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))
        XCTAssertTrue(opml.contains("<opml version=\"2.0\">"))
        XCTAssertTrue(opml.contains("<title>Test Export</title>"))
        XCTAssertTrue(opml.contains("Feed 1"))
        XCTAssertTrue(opml.contains("Feed 2"))
        XCTAssertTrue(opml.contains("Feed 3"))
        XCTAssertTrue(opml.contains("https://example.com/feed1.xml"))
        XCTAssertTrue(opml.contains("</opml>"))
    }
    
    func testGenerateWithXMLEscaping() {
        let feeds = [
            RSSFeed(title: "Feed & Co", urlString: "https://example.com/feed?a=1&b=2"),
            RSSFeed(title: "Feed <test>", urlString: "https://example.com/feed")
        ]
        
        let opml = OPMLParser.generate(feeds: feeds)
        
        XCTAssertTrue(opml.contains("&amp;"))
        XCTAssertTrue(opml.contains("&lt;"))
        XCTAssertTrue(opml.contains("&gt;"))
        XCTAssertFalse(opml.contains("Feed & Co")) // Should be escaped
        XCTAssertFalse(opml.contains("Feed <test>")) // Should be escaped
    }
    
    func testGenerateEmptyOPML() {
        let feeds: [RSSFeed] = []
        let opml = OPMLParser.generate(feeds: feeds)
        
        XCTAssertTrue(opml.contains("<body>"))
        XCTAssertTrue(opml.contains("</body>"))
        // Should have valid structure even with no feeds
        XCTAssertTrue(opml.contains("<opml"))
        XCTAssertTrue(opml.contains("</opml>"))
    }
    
    // MARK: - XML Escaping Tests
    
    func testXMLEscaping() {
        XCTAssertEqual("test & test".xmlEscaped, "test &amp; test")
        XCTAssertEqual("<tag>".xmlEscaped, "&lt;tag&gt;")
        XCTAssertEqual("\"quote\"".xmlEscaped, "&quot;quote&quot;")
        XCTAssertEqual("'apostrophe'".xmlEscaped, "&apos;apostrophe&apos;")
        XCTAssertEqual("a & b < c > d".xmlEscaped, "a &amp; b &lt; c &gt; d")
    }
    
    func testXMLEscapingOrder() {
        // & must be escaped first
        let input = "&<>"
        let escaped = input.xmlEscaped
        XCTAssertEqual(escaped, "&amp;&lt;&gt;")
        XCTAssertFalse(escaped.contains("&amp;lt;")) // Should not double-escape
    }
    
    // MARK: - Round-trip Tests
    
    func testRoundTrip() throws {
        let originalFeeds = [
            RSSFeed(title: "Apple News", urlString: "https://www.apple.com/newsroom/rss-feed.rss"),
            RSSFeed(title: "Swift Blog", urlString: "https://www.swift.org/blog/rss.xml")
        ]
        
        // Generate OPML
        let opml = OPMLParser.generate(feeds: originalFeeds)
        
        // Parse it back
        let data = opml.data(using: .utf8)!
        let parser = OPMLParser()
        let parsedFeeds = try parser.parse(data: data)
        
        XCTAssertEqual(parsedFeeds.count, originalFeeds.count)
        XCTAssertEqual(parsedFeeds[0].title, originalFeeds[0].title)
        XCTAssertEqual(parsedFeeds[0].xmlUrl, originalFeeds[0].urlString)
        XCTAssertEqual(parsedFeeds[1].title, originalFeeds[1].title)
        XCTAssertEqual(parsedFeeds[1].xmlUrl, originalFeeds[1].urlString)
    }
    
    // MARK: - Import Result Tests
    
    func testImportResultMessage() {
        let result = ImportResult(total: 10, imported: 5, skipped: 3, failed: 2)
        
        let message = result.message
        XCTAssertTrue(message.contains("5"))
        XCTAssertTrue(message.contains("3"))
        XCTAssertTrue(message.contains("2"))
    }
    
    func testImportResultOnlyImports() {
        let result = ImportResult(total: 5, imported: 5, skipped: 0, failed: 0)
        
        let message = result.message
        XCTAssertTrue(message.contains("5"))
        XCTAssertFalse(result.hasErrors)
        XCTAssertTrue(result.hasSuccess)
    }
    
    func testImportResultWithErrors() {
        let result = ImportResult(total: 5, imported: 3, skipped: 0, failed: 2)
        
        XCTAssertTrue(result.hasErrors)
        XCTAssertTrue(result.hasSuccess)
    }
    
    func testImportResultOnlySkipped() {
        let result = ImportResult(total: 5, imported: 0, skipped: 5, failed: 0)
        
        XCTAssertFalse(result.hasErrors)
        XCTAssertFalse(result.hasSuccess)
    }
}

// MARK: - Real-world OPML Examples

final class RealWorldOPMLTests: XCTestCase {
    
    func testParseFeedlyOPML() throws {
        // Feedly uses this format
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="1.0">
            <head>
                <title>Feedly OPML Export</title>
            </head>
            <body>
                <outline text="Tech" title="Tech">
                    <outline type="rss" text="TechCrunch" title="TechCrunch" 
                             xmlUrl="https://techcrunch.com/feed/" 
                             htmlUrl="https://techcrunch.com/"/>
                </outline>
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        // Should find the nested feed
        XCTAssertGreaterThanOrEqual(feeds.count, 1)
    }
    
    func testParseNetNewsWireOPML() throws {
        // NetNewsWire format
        let opmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
            <head>
                <title>NetNewsWire Subscriptions</title>
            </head>
            <body>
                <outline text="Apple Newsroom" 
                         type="rss" 
                         xmlUrl="https://www.apple.com/newsroom/rss-feed.rss"/>
            </body>
        </opml>
        """
        
        let data = opmlString.data(using: .utf8)!
        let parser = OPMLParser()
        let feeds = try parser.parse(data: data)
        
        XCTAssertEqual(feeds.count, 1)
        XCTAssertEqual(feeds[0].title, "Apple Newsroom")
    }
}
