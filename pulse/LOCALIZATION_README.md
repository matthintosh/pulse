# Guide de Localisation / Localization Guide

## 🌍 Langues supportées / Supported Languages

- 🇬🇧 English (Anglais)
- 🇫🇷 Français (French)

## 📁 Fichiers de localisation / Localization Files

Le fichier principal de localisation est `Localizable.xcstrings`, qui utilise le nouveau format String Catalog d'Apple. Ce format offre plusieurs avantages :

- ✅ Format JSON lisible et modifiable
- ✅ Support natif dans Xcode
- ✅ Gestion des pluriels et variations
- ✅ Suivi des traductions manquantes
- ✅ Export/Import facile

## 🔧 Configuration dans Xcode

1. **Ajouter une nouvelle langue** :
   - Sélectionnez votre projet dans le navigateur
   - Allez dans l'onglet "Info"
   - Sous "Localizations", cliquez sur "+"
   - Sélectionnez la langue souhaitée

2. **Tester une langue spécifique** :
   - Dans Xcode, allez dans "Product" > "Scheme" > "Edit Scheme..."
   - Sous "Run", sélectionnez "Options"
   - Changez "App Language" vers la langue souhaitée
   - Exécutez l'application

## 💻 Utilisation dans le code / Usage in Code

### Texte simple / Simple Text

```swift
Text("Welcome to Pulse", bundle: .main, comment: "Welcome title")
```

### Texte avec variable / Text with Variable

```swift
Text("Updated \(time, style: .relative) ago", bundle: .main, comment: "Last update time")
```

### String dans le code / String in Code

```swift
let message = String(localized: "Add Feed", comment: "Add feed button")
```

### Label avec localisation / Localized Label

```swift
Label(String(localized: "All Feeds", comment: "Filter option"), systemImage: "line.3.horizontal")
```

## 📝 Ajouter une nouvelle traduction / Adding New Translations

### Option 1 : Directement dans Xcode

1. Ouvrez `Localizable.xcstrings` dans Xcode
2. Cliquez sur "+" pour ajouter une nouvelle clé
3. Entrez la clé en anglais
4. Ajoutez les traductions pour chaque langue
5. Ajoutez un commentaire pour le contexte

### Option 2 : Éditer le fichier JSON

Ajoutez une nouvelle entrée dans le fichier `Localizable.xcstrings` :

```json
"Your New Text" : {
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Your New Text"
      }
    },
    "fr" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Votre Nouveau Texte"
      }
    }
  }
}
```

## 🎯 Bonnes pratiques / Best Practices

1. **Toujours ajouter un commentaire** :
   ```swift
   Text("Add", bundle: .main, comment: "Button to add a new item")
   ```
   Le commentaire aide les traducteurs à comprendre le contexte.

2. **Utiliser des clés descriptives** :
   - ✅ "Add Your First Feed"
   - ❌ "button1"

3. **Éviter les concaténations** :
   - ❌ `Text("Hello") + Text(name) + Text("!")`
   - ✅ `Text("Hello \(name)!", bundle: .main, comment: "Greeting")`

4. **Tester toutes les langues** avant de publier

5. **Extraire les textes longs** dans des fichiers séparés si nécessaire

## 🔍 Vérifier les traductions manquantes / Check Missing Translations

Dans Xcode :
1. Ouvrez `Localizable.xcstrings`
2. Les traductions manquantes sont marquées avec un ⚠️
3. Les traductions en attente sont marquées comme "needs review"

## 📱 Traductions actuelles / Current Translations

### Interface Principale / Main Interface
- ✅ "Pulse" (titre de l'app)
- ✅ "Welcome to Pulse"
- ✅ "Search articles"
- ✅ "All Feeds"
- ✅ "Add Your First Feed"
- ✅ "Add Sample Feeds"

### Gestion des Flux / Feed Management
- ✅ "Manage Feeds"
- ✅ "Add Feed"
- ✅ "Add RSS Feed"
- ✅ "Feed Name"
- ✅ "RSS URL"
- ✅ "Popular Feeds"
- ✅ "No RSS Feeds"

### Articles
- ✅ "Read Full Article"
- ✅ "Opens in Reader Mode"
- ✅ "Mark as Read"
- ✅ "Mark as Unread"
- ✅ "Share"
- ✅ "No articles yet"
- ✅ "No matching articles"

### Actions
- ✅ "Add"
- ✅ "Cancel"
- ✅ "Done"

## 🚀 Pour ajouter une nouvelle langue / To Add a New Language

1. Ouvrez le fichier `Localizable.xcstrings`
2. Ajoutez le code de la langue (ex: "es" pour espagnol, "de" pour allemand)
3. Pour chaque clé, ajoutez une section de traduction :

```json
"Welcome to Pulse" : {
  "localizations" : {
    "en" : { ... },
    "fr" : { ... },
    "es" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Bienvenido a Pulse"
      }
    }
  }
}
```

## 📞 Support

Pour toute question sur la localisation, consultez la documentation Apple :
- [String Catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
- [Localization Guide](https://developer.apple.com/localization/)
