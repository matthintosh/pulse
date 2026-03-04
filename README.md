# Pulse - RSS Reader with Liquid Glass Design

A modern RSS reader application built with SwiftUI, featuring Apple's Liquid Glass design language for a beautiful, fluid user experience.

## Features

### Core Functionality
- **RSS Feed Management**: Add, view, and delete RSS feeds
- **Article Reading**: Browse articles with images and descriptions
- **Full Article View**: Read complete articles with beautiful formatting
- **Pull-to-Refresh**: Update all feeds with a simple gesture
- **Search**: Find articles by title or description
- **Filter Options**: View all articles, filter by feed, or show unread only
- **Mark as Read**: Automatically or manually mark articles as read
- **Share Articles**: Share article links with others

### Liquid Glass Design Implementation

This app showcases the complete Liquid Glass design system:

#### 1. **Glass Effect on Cards** (`ArticleCardView.swift`)
- Interactive glass cards for each article
- Beautiful blurred backgrounds with depth
- Hover/touch reactions for interactive feedback

```swift
.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
```

#### 2. **Glass Button Styles**
- `.glass` - Standard glass buttons in toolbars
- `.glassProminent` - Emphasized glass buttons for primary actions

```swift
Button("Add") { }
    .buttonStyle(.glassProminent)
```

#### 3. **Glass Effect Container** (`ContentView.swift`, `FeedManagementView.swift`)
- Properly spaces glass effects so they can merge
- Enables fluid blending between nearby elements

```swift
GlassEffectContainer(spacing: 20) {
    LazyVStack(spacing: 16) {
        // Glass effect views
    }
}
```

#### 4. **Custom Glass Shapes**
- Circles for icons and indicators
- Rounded rectangles for cards and containers
- Tinted glass for emphasis

```swift
.glassEffect(.regular.tint(.blue), in: .circle)
```

#### 5. **Interactive Glass Elements**
- Touch and pointer reactions
- Smooth morphing transitions
- Unified glass effects with proper spacing

### Architecture

#### Data Models
- **RSSFeed**: Stores feed information (title, URL, last updated)
- **RSSArticle**: Stores article data (title, description, content, images, read state)
- Relationships: One feed has many articles (cascade delete)

#### Services
- **RSSParser**: XML parser for RSS/Atom feeds
- **RSSService**: Async feed fetching and data persistence

#### Views
- **ContentView**: Main article list with filters and search
- **ArticleCardView**: Liquid Glass card for each article
- **ArticleDetailView**: Full article reading experience
- **FeedManagementView**: Manage RSS feed subscriptions
- **AddFeedView**: Add new feeds with popular suggestions

### SwiftUI Features Used

- **SwiftData**: Modern data persistence
- **Swift Concurrency**: Async/await for network requests
- **NavigationStack**: Modern navigation system
- **SearchableModifier**: Built-in search
- **Refreshable**: Pull-to-refresh gesture
- **ShareLink**: Native sharing
- **AsyncImage**: Async image loading
- **@Query**: Reactive database queries

### Liquid Glass Best Practices Demonstrated

1. **Consistent Spacing**: Using `GlassEffectContainer` with appropriate spacing values
2. **Interactive Elements**: Glass effects on buttons and cards respond to touch
3. **Proper Layering**: Glass effects applied after content modifiers
4. **Shape Consistency**: Maintaining design language with rounded corners
5. **Tinting**: Using tints to indicate importance or state
6. **Performance**: Efficient use of glass containers to reduce rendering overhead

## Usage

### Adding Feeds
1. Tap the gear icon in the toolbar
2. Tap the plus button
3. Enter feed name and URL, or select from popular feeds
4. Tap "Add" to fetch and display articles

### Reading Articles
1. Tap any article card to read the full content
2. Articles are automatically marked as read
3. Tap the checkmark icon to toggle read status
4. Tap the share icon to share the article

### Managing Articles
- Use the filter menu to select a specific feed
- Toggle the envelope icon to show only unread articles
- Use the search bar to find specific articles
- Pull down to refresh all feeds

### Sample Feeds Included
- Apple Newsroom
- Swift.org Blog
- Hacker News
- TechCrunch

## Platform Support

This app is designed to work on:
- iOS 17+
- iPadOS 17+
- macOS 14+ (with platform-specific adaptations)

The Liquid Glass design automatically adapts to each platform's design language.

## Implementation Notes

### Network Permissions
Make sure to add the following to your `Info.plist` for network access:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Note: For production apps, use specific domain exceptions instead of allowing arbitrary loads.

### Dependencies
- No external dependencies required
- Uses only Apple frameworks:
  - SwiftUI
  - SwiftData
  - Foundation

## Future Enhancements

Potential improvements:
- Offline reading mode
- Article bookmarking
- Reading progress tracking
- Dark mode optimization
- Widget support with Liquid Glass
- macOS menu bar integration
- OPML import/export
- Article categories/tags
- Reader mode (text-only view)

## Design Philosophy

This app demonstrates that modern design doesn't require complexity. The Liquid Glass design system provides:
- **Visual Hierarchy**: Glass effects create natural depth
- **Consistency**: Unified design language throughout
- **Interactivity**: Reactive elements feel alive
- **Accessibility**: Clear contrast and readable text
- **Performance**: Efficient rendering with proper containers

---

Built with ❤️ using SwiftUI and Liquid Glass design
