//
//  ReaderModeView.swift
//  pulse
//
//  Created by Matthieu Rocher on 05/03/2026.
//

import SwiftUI
import SwiftData

struct ReaderModeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let article: RSSArticle
    
    @State private var fontSize: CGFloat = 18
    @State private var showSettings = false
    
    // Font size options
    private let fontSizes: [CGFloat] = [14, 16, 18, 20, 22, 24, 28]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        // Feed and Date
                        HStack(spacing: 8) {
                            if let feedTitle = article.feed?.title {
                                Text(feedTitle)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.blue)
                            }
                            
                            Text("•")
                                .foregroundStyle(.quaternary)
                            
                            Text(article.publishDate, format: .dateTime.day().month().year())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        // Title
                        Text(article.title)
                            .font(.system(size: fontSize + 8, weight: .bold, design: .serif))
                            .foregroundStyle(.primary)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Article Content
                    VStack(alignment: .leading, spacing: 16) {
                        // Description/Summary
                        if !article.articleDescription.isEmpty {
                            Text(article.articleDescription)
                                .font(.system(size: fontSize + 2, design: .serif))
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 8)
                        }
                        
                        // Main Content
                        Text(article.content)
                            .font(.system(size: fontSize, design: .serif))
                            .foregroundStyle(.primary)
                            .lineSpacing(8)
                            .textSelection(.enabled)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(readerBackground)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Reader Mode", bundle: .main, comment: "Reader mode title")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "textformat.size")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(item: URL(string: article.link)!) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                ReaderSettingsView(fontSize: $fontSize)
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var readerBackground: Color {
        colorScheme == .dark ? Color(white: 0.12) : Color(white: 0.98)
    }
}

// MARK: - Reader Settings

struct ReaderSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var fontSize: CGFloat
    
    private let fontSizes: [CGFloat] = [14, 16, 18, 20, 22, 24, 28]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Font Size Control
                VStack(spacing: 20) {
                    HStack {
                        Text("Font Size", bundle: .main, comment: "Font size label")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(fontSize))pt")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Font size buttons
                    HStack(spacing: 12) {
                        Button {
                            decreaseFontSize()
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                                .foregroundStyle(fontSize > fontSizes.first! ? .blue : .gray)
                        }
                        .disabled(fontSize <= fontSizes.first!)
                        
                        // Preview text
                        Text("Aa")
                            .font(.system(size: fontSize, design: .serif))
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            increaseFontSize()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundStyle(fontSize < fontSizes.last! ? .blue : .gray)
                        }
                        .disabled(fontSize >= fontSizes.last!)
                    }
                }
                .padding(20)
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
                
                // Reset button
                Button {
                    fontSize = 18 // Default
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset to Default", bundle: .main, comment: "Reset button")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding()
            .navigationTitle(String(localized: "Reader Settings", comment: "Reader settings title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done", comment: "Done button")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func increaseFontSize() {
        if let currentIndex = fontSizes.firstIndex(of: fontSize),
           currentIndex < fontSizes.count - 1 {
            fontSize = fontSizes[currentIndex + 1]
        }
    }
    
    private func decreaseFontSize() {
        if let currentIndex = fontSizes.firstIndex(of: fontSize),
           currentIndex > 0 {
            fontSize = fontSizes[currentIndex - 1]
        }
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RSSArticle.self, RSSFeed.self, configurations: config)
    let context = container.mainContext
    
    let feed = RSSFeed(title: "Tech News Daily", urlString: "https://example.com")
    
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
        link: "https://example.com/article",
        imageURL: nil,
        publishDate: Date()
    )
    article.feed = feed
    
    context.insert(feed)
    context.insert(article)
    
    return ReaderModeView(article: article)
        .modelContainer(container)
}
