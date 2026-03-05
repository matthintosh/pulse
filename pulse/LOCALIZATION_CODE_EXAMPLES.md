# 💻 Exemples de Code - Localisation / Code Examples - Localization

Guide pratique avec exemples de code pour utiliser la localisation dans votre application.

---

## 📋 Table des Matières / Table of Contents

1. [Text Views](#text-views)
2. [Buttons](#buttons)
3. [Labels](#labels)
4. [Navigation](#navigation)
5. [Alerts et Dialogs](#alerts-et-dialogs)
6. [TextFields et Forms](#textfields-et-forms)
7. [Strings dans le Code](#strings-dans-le-code)
8. [Pluriels et Variables](#pluriels-et-variables)
9. [Dates et Nombres](#dates-et-nombres)
10. [Bonnes Pratiques](#bonnes-pratiques)

---

## 1. Text Views

### ✅ Simple Text

```swift
// Basic
Text("Welcome to Pulse", bundle: .main, comment: "Welcome message")

// Avec style
Text("Add Feed", bundle: .main, comment: "Button label")
    .font(.headline)
    .foregroundStyle(.blue)
```

### ✅ Text Multi-lignes

```swift
Text("Your beautiful RSS reader with\nLiquid Glass design", 
     bundle: .main, 
     comment: "App description")
    .multilineTextAlignment(.center)
```

### ✅ Text avec Formatting

```swift
// Gras
Text("Important Message", bundle: .main, comment: "Alert title")
    .bold()

// Italique
Text("Optional subtitle", bundle: .main, comment: "Subtitle")
    .italic()
```

---

## 2. Buttons

### ✅ Button avec Text

```swift
Button {
    // Action
} label: {
    Text("Add", bundle: .main, comment: "Add button")
}
```

### ✅ Button avec Label

```swift
Button {
    // Action
} label: {
    Label(
        String(localized: "Add Feed", comment: "Add feed button"),
        systemImage: "plus"
    )
}
.buttonStyle(.borderedProminent)
```

### ✅ Button dans Toolbar

```swift
.toolbar {
    ToolbarItem(placement: .primaryAction) {
        Button(String(localized: "Done", comment: "Done button")) {
            dismiss()
        }
    }
}
```

---

## 3. Labels

### ✅ Label Simple

```swift
Label(
    String(localized: "Share", comment: "Share action"),
    systemImage: "square.and.arrow.up"
)
```

### ✅ Label avec Icon Only

```swift
Label(
    String(localized: "Mark as Read", comment: "Mark as read action"),
    systemImage: "checkmark.circle"
)
.labelStyle(.iconOnly)
```

### ✅ Label Personnalisé

```swift
Label {
    Text("Popular Feeds", bundle: .main, comment: "Section title")
        .font(.headline)
} icon: {
    Image(systemName: "star.fill")
        .foregroundStyle(.yellow)
}
```

---

## 4. Navigation

### ✅ Navigation Title

```swift
.navigationTitle(String(localized: "Manage Feeds", comment: "Feed management screen title"))
```

### ✅ Navigation Bar Items

```swift
.navigationBarItems(
    trailing: Button(String(localized: "Cancel", comment: "Cancel button")) {
        dismiss()
    }
)
```

### ✅ Tab View

```swift
TabView {
    FeedsView()
        .tabItem {
            Label(
                String(localized: "Feeds", comment: "Feeds tab"),
                systemImage: "list.bullet"
            )
        }
    
    SettingsView()
        .tabItem {
            Label(
                String(localized: "Settings", comment: "Settings tab"),
                systemImage: "gear"
            )
        }
}
```

---

## 5. Alerts et Dialogs

### ✅ Simple Alert

```swift
.alert(
    String(localized: "Error", comment: "Error alert title"),
    isPresented: $showError
) {
    Button(String(localized: "OK", comment: "OK button")) {
        // Action
    }
} message: {
    Text("Failed to load feed", bundle: .main, comment: "Feed load error")
}
```

### ✅ Confirmation Dialog

```swift
.confirmationDialog(
    String(localized: "Delete Feed?", comment: "Delete confirmation title"),
    isPresented: $showConfirmation
) {
    Button(
        String(localized: "Delete", comment: "Delete button"),
        role: .destructive
    ) {
        deleteFeed()
    }
    
    Button(
        String(localized: "Cancel", comment: "Cancel button"),
        role: .cancel
    ) { }
} message: {
    Text("This action cannot be undone", 
         bundle: .main, 
         comment: "Delete warning message")
}
```

---

## 6. TextFields et Forms

### ✅ TextField avec Placeholder

```swift
TextField(
    String(localized: "Feed Name", comment: "Feed name placeholder"),
    text: $feedName
)
```

### ✅ Section avec Header

```swift
Section {
    TextField("https://example.com/feed.xml", text: $feedURL)
} header: {
    Text("RSS URL", bundle: .main, comment: "RSS URL section header")
}
```

### ✅ Form Complète

```swift
Form {
    Section {
        TextField(
            String(localized: "Feed Name", comment: "Feed name field"),
            text: $feedName
        )
    } header: {
        Text("Name", bundle: .main, comment: "Name section")
    } footer: {
        Text("Enter a name for this feed", 
             bundle: .main, 
             comment: "Name field help text")
    }
}
```

---

## 7. Strings dans le Code

### ✅ Variable String

```swift
let welcomeMessage = String(
    localized: "Welcome to Pulse",
    comment: "Welcome message shown on first launch"
)
```

### ✅ String avec Variable

```swift
// Dans Localizable.xcstrings:
// "Welcome, %@!" pour les deux langues

let userName = "John"
let greeting = String(
    localized: "Welcome, \(userName)!",
    comment: "Personalized greeting"
)
```

### ✅ Error Messages

```swift
enum FeedError: LocalizedError {
    case invalidURL
    case networkError
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(
                localized: "Invalid feed URL",
                comment: "Invalid URL error message"
            )
        case .networkError:
            return String(
                localized: "Network connection failed",
                comment: "Network error message"
            )
        case .parsingError:
            return String(
                localized: "Failed to parse feed",
                comment: "Parsing error message"
            )
        }
    }
}
```

---

## 8. Pluriels et Variables

### ✅ Avec Count

```swift
// Dans Localizable.xcstrings, ajoutez une entrée avec pluralization:
// "%lld articles" avec variations pour zero, one, other

let count = articles.count
let message = String(
    localized: "\(count) articles",
    comment: "Number of articles"
)
```

### ✅ Format String

```swift
// Dans Localizable.xcstrings:
// EN: "Updated %@ ago"
// FR: "Mis à jour il y a %@"

let timeText = String(
    localized: "Updated \(timeInterval) ago",
    comment: "Last update time"
)
```

### ✅ Multiple Variables

```swift
// Dans Localizable.xcstrings:
// EN: "%@ published by %@"
// FR: "%@ publié par %@"

let title = "Article Title"
let author = "John Doe"
let text = String(
    localized: "\(title) published by \(author)",
    comment: "Article attribution"
)
```

---

## 9. Dates et Nombres

### ✅ Date Formatting

```swift
// Relatif
Text(article.publishDate, style: .relative)

// Date complète
Text(article.publishDate, format: .dateTime.day().month().year())

// Date et heure
Text(article.publishDate, format: .dateTime)
```

### ✅ Number Formatting

```swift
// Nombre simple
Text(count, format: .number)

// Pourcentage
Text(percentage, format: .percent)

// Monnaie
Text(price, format: .currency(code: "EUR"))
```

---

## 10. Bonnes Pratiques

### ✅ Contextual Comments

```swift
// ✅ BON - Commentaire descriptif
Text("Add", bundle: .main, comment: "Button to add a new RSS feed")

// ❌ MAUVAIS - Pas de commentaire
Text("Add", bundle: .main)

// ❌ MAUVAIS - Commentaire inutile
Text("Add", bundle: .main, comment: "Add")
```

### ✅ Descriptive Keys

```swift
// ✅ BON - Clé descriptive
String(localized: "Add Your First Feed", comment: "Empty state call to action")

// ❌ MAUVAIS - Clé générique
String(localized: "button1", comment: "First button")
```

### ✅ Éviter les Concaténations

```swift
// ❌ MAUVAIS - Concaténation
let fullName = firstName + " " + lastName

// ✅ BON - Interpolation
let fullName = String(
    localized: "\(firstName) \(lastName)",
    comment: "Full name format"
)
```

### ✅ Long Texts

```swift
// Pour les textes longs, créez une entrée séparée
let helpText = String(
    localized: """
        To add an RSS feed:
        1. Tap the plus button
        2. Enter the feed URL
        3. Tap Add
        """,
    comment: "Help text for adding feeds"
)
```

---

## 📝 Template pour Nouveaux Fichiers / Template for New Files

```swift
import SwiftUI

struct NewView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Text Here", bundle: .main, comment: "Description")
            }
            .navigationTitle(String(localized: "View Title", comment: "Navigation title"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(String(localized: "Action", comment: "Action button")) {
                        // Action
                    }
                }
            }
        }
    }
}
```

---

## 🔍 Rechercher du Texte Non Localisé / Find Non-Localized Text

### Regex pour trouver Text non localisé

```regex
Text\("([^"]+)"\)(?!.*bundle)
```

### Patterns à chercher

```swift
// ❌ À remplacer
Text("Some text")
Label("Some text", systemImage: "icon")
Button("Text") { }

// ✅ Correct
Text("Some text", bundle: .main, comment: "...")
Label(String(localized: "Some text", comment: "..."), systemImage: "icon")
Button(String(localized: "Text", comment: "...")) { }
```

---

## 🧪 Testing Helpers

### SwiftUI Preview avec Langue

```swift
#Preview("English") {
    ContentView()
        .environment(\.locale, Locale(identifier: "en"))
}

#Preview("French") {
    ContentView()
        .environment(\.locale, Locale(identifier: "fr"))
}
```

### Mock Data Localisé

```swift
extension RSSFeed {
    static var previewFeed: RSSFeed {
        RSSFeed(
            title: String(localized: "Example Feed", comment: "Preview feed title"),
            urlString: "https://example.com/feed.xml"
        )
    }
}
```

---

## 📦 Extension Utiles / Useful Extensions

### String Extension

```swift
extension String {
    /// Localise facilement une string
    func localized(comment: String = "") -> String {
        String(localized: String.LocalizationValue(self), comment: comment)
    }
}

// Usage
let text = "Welcome to Pulse".localized(comment: "Welcome message")
```

### Text Extension

```swift
extension Text {
    /// Crée un Text localisé
    static func localized(
        _ key: String,
        comment: StaticString = ""
    ) -> Text {
        Text(key, bundle: .main, comment: comment)
    }
}

// Usage
Text.localized("Welcome to Pulse", comment: "Welcome message")
```

---

## 🎯 Checklist par Type de Vue / Checklist per View Type

### List/Table View
- [ ] Section headers localisés
- [ ] Empty state message localisé
- [ ] Cell labels localisés
- [ ] Swipe actions localisées
- [ ] Navigation title localisé

### Detail View
- [ ] Titre localisé
- [ ] Labels de champs localisés
- [ ] Boutons d'action localisés
- [ ] Messages d'erreur localisés
- [ ] Share message localisé

### Form/Input View
- [ ] Field labels localisés
- [ ] Placeholders localisés
- [ ] Help text localisé
- [ ] Error messages localisés
- [ ] Submit button localisé
- [ ] Cancel button localisé

### Settings View
- [ ] Section headers localisés
- [ ] Setting labels localisés
- [ ] Description text localisé
- [ ] Confirmation dialogs localisés

---

## 💡 Pro Tips

### 1. Commenter pendant le Développement

```swift
// TODO: Localize
Text("Temporary text")

// Puis remplacer par:
Text("Final text", bundle: .main, comment: "Description")
```

### 2. Constantes pour Clés Communes

```swift
enum LocalizedString {
    static let add = String(localized: "Add", comment: "Add button")
    static let cancel = String(localized: "Cancel", comment: "Cancel button")
    static let done = String(localized: "Done", comment: "Done button")
    static let delete = String(localized: "Delete", comment: "Delete button")
}

// Usage
Button(LocalizedString.add) { }
```

### 3. Preview avec les Deux Langues

```swift
#Preview {
    HStack {
        ContentView()
            .environment(\.locale, Locale(identifier: "en"))
        
        ContentView()
            .environment(\.locale, Locale(identifier: "fr"))
    }
}
```

---

## 🐛 Débogage / Debugging

### Afficher la Langue Actuelle

```swift
struct DebugLanguageView: View {
    var body: some View {
        Text("Current locale: \(Locale.current.identifier)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
```

### Logger les Traductions Manquantes

```swift
import OSLog

let logger = Logger(subsystem: "com.pulse.app", category: "Localization")

func localizedText(_ key: String, comment: String) -> String {
    let text = String(localized: String.LocalizationValue(key), comment: comment)
    if text == key {
        logger.warning("Missing translation for: \(key)")
    }
    return text
}
```

---

**Happy Coding! 💻**
**Bon Codage ! 💻**

Pour plus d'informations, consultez :
- [LOCALIZATION_README.md](LOCALIZATION_README.md)
- [QUICK_START_LOCALIZATION.md](QUICK_START_LOCALIZATION.md)
- [CONFIGURATION_XCODE.md](CONFIGURATION_XCODE.md)
