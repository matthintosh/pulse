# Pulse - RSS Reader with Liquid Glass Design / Lecteur RSS avec Design Liquid Glass

[🇬🇧 English](#english) | [🇫🇷 Français](#français)

---

## English

A modern RSS reader application built with SwiftUI, featuring Apple's Liquid Glass design language for a beautiful, fluid user experience.

### ✨ Features

#### Core Functionality
- **RSS Feed Management**: Add, view, and delete RSS feeds
- **Article Reading**: Browse articles with images and descriptions
- **Full Article View**: Read complete articles with beautiful formatting
- **Pull-to-Refresh**: Update all feeds with a simple gesture
- **Search**: Find articles by title or description
- **Filter Options**: View all articles, filter by feed, or show unread only
- **Mark as Read**: Automatically or manually mark articles as read
- **Share Articles**: Share article links with others
- **🌍 Multilingual**: Full support for English and French

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
- ~~OPML import/export~~ ✅ **Implemented!**
- Article categories/tags
- ~~Reader mode (text-only view)~~ ✅ **Implemented!**

## Design Philosophy

This app demonstrates that modern design doesn't require complexity. The Liquid Glass design system provides:
- **Visual Hierarchy**: Glass effects create natural depth
- **Consistency**: Unified design language throughout
- **Interactivity**: Reactive elements feel alive
- **Accessibility**: Clear contrast and readable text
- **Performance**: Efficient rendering with proper containers

---

Built with ❤️ using SwiftUI and Liquid Glass design
---

## Français

Une application moderne de lecture RSS construite avec SwiftUI, intégrant le langage de design Liquid Glass d'Apple pour une expérience utilisateur fluide et élégante.

### ✨ Fonctionnalités

#### Fonctionnalités principales
- **Gestion des flux RSS** : Ajoutez, visualisez et supprimez des flux RSS
- **Lecture d'articles** : Parcourez les articles avec images et descriptions
- **Vue article complète** : Lisez les articles complets avec un formatage élégant
- **Tirer pour actualiser** : Mettez à jour tous les flux d'un simple geste
- **Recherche** : Trouvez des articles par titre ou description
- **Options de filtrage** : Affichez tous les articles, filtrez par flux ou affichez uniquement les non lus
- **Marquer comme lu** : Marquez automatiquement ou manuellement les articles comme lus
- **Partager des articles** : Partagez les liens d'articles avec d'autres
- **🌍 Multilingue** : Support complet de l'anglais et du français

### Design Liquid Glass

Cette application présente le système de design Liquid Glass complet :

#### 1. **Effet verre sur les cartes** (`ArticleCardView.swift`)
- Cartes en verre interactives pour chaque article
- Beaux arrière-plans flous avec profondeur
- Réactions au survol/toucher pour un retour interactif

```swift
.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
```

#### 2. **Styles de boutons en verre**
- `.glass` - Boutons en verre standard dans les barres d'outils
- `.glassProminent` - Boutons en verre mis en avant pour les actions principales

```swift
Button("Ajouter") { }
    .buttonStyle(.glassProminent)
```

#### 3. **Conteneur d'effet verre** (`ContentView.swift`, `FeedManagementView.swift`)
- Espace correctement les effets de verre pour qu'ils puissent fusionner
- Active le mélange fluide entre les éléments proches

```swift
GlassEffectContainer(spacing: 20) {
    LazyVStack(spacing: 16) {
        // Vues avec effet verre
    }
}
```

#### 4. **Formes de verre personnalisées**
- Cercles pour les icônes et indicateurs
- Rectangles arrondis pour les cartes et conteneurs
- Verre teinté pour l'emphase

```swift
.glassEffect(.regular.tint(.blue), in: .circle)
```

#### 5. **Éléments de verre interactifs**
- Réactions au toucher et au pointeur
- Transitions de morphing fluides
- Effets de verre unifiés avec espacement approprié

### Architecture

#### Modèles de données
- **RSSFeed** : Stocke les informations des flux (titre, URL, dernière mise à jour)
- **RSSArticle** : Stocke les données des articles (titre, description, contenu, images, état de lecture)
- Relations : Un flux a plusieurs articles (suppression en cascade)

#### Services
- **RSSParser** : Analyseur XML pour les flux RSS/Atom
- **RSSService** : Récupération asynchrone des flux et persistance des données

#### Vues
- **ContentView** : Liste principale des articles avec filtres et recherche
- **ArticleCardView** : Carte Liquid Glass pour chaque article
- **ArticleDetailView** : Expérience de lecture complète d'article
- **FeedManagementView** : Gérer les abonnements aux flux RSS
- **AddFeedView** : Ajouter de nouveaux flux avec suggestions populaires

### Fonctionnalités SwiftUI utilisées

- **SwiftData** : Persistance moderne des données
- **Swift Concurrency** : Async/await pour les requêtes réseau
- **NavigationStack** : Système de navigation moderne
- **SearchableModifier** : Recherche intégrée
- **Refreshable** : Geste de tirer pour actualiser
- **ShareLink** : Partage natif
- **AsyncImage** : Chargement asynchrone d'images
- **@Query** : Requêtes de base de données réactives

### Meilleures pratiques Liquid Glass démontrées

1. **Espacement cohérent** : Utilisation de `GlassEffectContainer` avec des valeurs d'espacement appropriées
2. **Éléments interactifs** : Les effets de verre sur les boutons et cartes répondent au toucher
3. **Superposition appropriée** : Effets de verre appliqués après les modificateurs de contenu
4. **Cohérence des formes** : Maintien du langage de design avec des coins arrondis
5. **Teinte** : Utilisation de teintes pour indiquer l'importance ou l'état
6. **Performance** : Utilisation efficace des conteneurs de verre pour réduire la charge de rendu

## Utilisation

### Ajout de flux
1. Appuyez sur l'icône d'engrenage dans la barre d'outils
2. Appuyez sur le bouton plus
3. Entrez le nom et l'URL du flux, ou sélectionnez parmi les flux populaires
4. Appuyez sur "Ajouter" pour récupérer et afficher les articles

### Lecture d'articles
1. Appuyez sur n'importe quelle carte d'article pour lire le contenu complet
2. Les articles sont automatiquement marqués comme lus
3. Appuyez sur l'icône de coche pour basculer l'état de lecture
4. Appuyez sur l'icône de partage pour partager l'article

### Gestion des articles
- Utilisez le menu de filtrage pour sélectionner un flux spécifique
- Basculez l'icône d'enveloppe pour n'afficher que les articles non lus
- Utilisez la barre de recherche pour trouver des articles spécifiques
- Tirez vers le bas pour actualiser tous les flux

### Flux d'exemple inclus
- Apple Newsroom
- Swift.org Blog
- Hacker News
- TechCrunch

## Support des plateformes

Cette application est conçue pour fonctionner sur :
- iOS 17+
- iPadOS 17+
- macOS 14+ (avec adaptations spécifiques à la plateforme)

Le design Liquid Glass s'adapte automatiquement au langage de design de chaque plateforme.

## 🌍 Localisation

L'application supporte nativement l'anglais et le français. La langue de l'interface s'adapte automatiquement aux paramètres de votre appareil.

Pour plus d'informations sur la localisation, consultez le [Guide de Localisation](LOCALIZATION_README.md).

### Langues disponibles
- 🇬🇧 English
- 🇫🇷 Français

## Notes d'implémentation

### Permissions réseau
Assurez-vous d'ajouter ce qui suit à votre `Info.plist` pour l'accès réseau :

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Note : Pour les applications en production, utilisez des exceptions de domaine spécifiques au lieu d'autoriser les chargements arbitraires.

### Dépendances
- Aucune dépendance externe requise
- Utilise uniquement les frameworks Apple :
  - SwiftUI
  - SwiftData
  - Foundation
  - SafariServices

## Améliorations futures

Améliorations potentielles :
- Mode lecture hors ligne
- Système de favoris d'articles
- Suivi de la progression de lecture
- Optimisation du mode sombre
- Support des widgets avec Liquid Glass
- Intégration à la barre de menus macOS
- ~~Import/export OPML~~ ✅ **Implémenté !**
- Catégories/tags d'articles
- ~~Mode lecteur (vue texte uniquement)~~ ✅ **Implémenté !**

## Philosophie de design

Cette application démontre que le design moderne ne nécessite pas de complexité. Le système de design Liquid Glass fournit :
- **Hiérarchie visuelle** : Les effets de verre créent une profondeur naturelle
- **Cohérence** : Langage de design unifié tout au long
- **Interactivité** : Les éléments réactifs semblent vivants
- **Accessibilité** : Contraste clair et texte lisible
- **Performance** : Rendu efficace avec des conteneurs appropriés

---

Construit avec ❤️ en utilisant SwiftUI et le design Liquid Glass

