# 📤📥 Guide OPML Import/Export

## 🎯 Qu'est-ce que OPML ? / What is OPML?

**OPML** (Outline Processor Markup Language) est le format standard utilisé par tous les lecteurs RSS pour échanger des listes de flux. C'est comme un "carnet d'adresses" pour vos flux RSS.

---

## ✨ Fonctionnalités / Features

### 📤 Export
- Sauvegardez tous vos flux RSS dans un fichier
- Partagez votre liste avec d'autres appareils
- Créez des backups réguliers
- Format compatible avec tous les lecteurs RSS

### 📥 Import
- Importez des flux depuis d'autres lecteurs RSS
- Restaurez vos flux après réinstallation
- Évite les doublons automatiquement
- Importe plusieurs flux en une seule fois

---

## 🚀 Comment Utiliser / How to Use

### Exporter vos flux / Export Your Feeds

1. **Ouvrez la gestion des flux**
   - Appuyez sur l'icône ⚙️ dans la barre d'outils

2. **Accédez à OPML**
   - Appuyez sur le bouton 🔄 (Import/Export OPML)

3. **Exportez**
   - Appuyez sur "Export X feeds"
   - Choisissez où sauvegarder :
     - 💾 Fichiers (iCloud Drive, local)
     - ✉️ Mail
     - 💬 Messages
     - Ou toute autre app de partage

4. **Fichier créé !**
   - Format : `pulse-feeds-YYYY-MM-DD.opml`
   - Contient tous vos flux

### Importer des flux / Import Feeds

1. **Ouvrez la gestion des flux**
   - Appuyez sur l'icône ⚙️

2. **Accédez à OPML**
   - Appuyez sur le bouton 🔄

3. **Importez**
   - Appuyez sur "Choose OPML File"
   - Sélectionnez votre fichier `.opml` ou `.xml`
   - Attendez l'import...

4. **Résultat**
   - Voir combien de flux ont été importés
   - Les doublons sont automatiquement ignorés
   - Les flux sont ajoutés immédiatement

---

## 📋 Format OPML / OPML Format

### Exemple de fichier OPML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<opml version="2.0">
    <head>
        <title>Pulse RSS Reader</title>
        <dateCreated>2026-03-05T10:00:00Z</dateCreated>
        <docs>http://www.opml.org/spec2</docs>
    </head>
    <body>
        <outline type="rss" text="Apple Newsroom" xmlUrl="https://www.apple.com/newsroom/rss-feed.rss" />
        <outline type="rss" text="Swift.org Blog" xmlUrl="https://www.swift.org/blog/rss.xml" />
        <outline type="rss" text="TechCrunch" xmlUrl="https://techcrunch.com/feed/" />
    </body>
</opml>
```

### Champs supportés / Supported Fields

| Champ | Description | Requis |
|-------|-------------|--------|
| `text` | Nom du flux | ✅ Oui |
| `xmlUrl` | URL du flux RSS | ✅ Oui |
| `htmlUrl` | Site web du flux | ❌ Non |
| `description` | Description | ❌ Non |

---

## 🎯 Cas d'Usage / Use Cases

### 1. 📱 Changement d'Appareil / Device Change
```
iPhone ancien → Export OPML → iPhone nouveau → Import OPML
```

### 2. 💾 Backup Régulier / Regular Backup
```
Chaque mois → Export OPML → Sauvegarder dans iCloud
```

### 3. 👥 Partage avec Amis / Share with Friends
```
Export OPML → Envoyer par Mail → Ami importe dans son lecteur
```

### 4. 🔄 Migration depuis autre app / Migrate from Other App
```
Feedly/NetNewsWire/etc. → Export OPML → Pulse → Import
```

---

## 🔒 Sécurité et Confidentialité / Security & Privacy

### ✅ Ce qui est exporté / What's Exported
- ✅ Titres des flux
- ✅ URLs des flux RSS
- ✅ Dates de création

### ❌ Ce qui N'est PAS exporté / What's NOT Exported
- ❌ Vos articles lus/non lus
- ❌ Vos favoris ou bookmarks
- ❌ Données personnelles
- ❌ Historique de navigation
- ❌ Recherches

**→ Le fichier OPML est 100% sûr à partager ! 🔒**

---

## 💡 Conseils Pro / Pro Tips

### 1. Nommez Vos Exports
```
pulse-feeds-travail.opml     → Flux professionnels
pulse-feeds-perso.opml       → Flux personnels
pulse-feeds-tech.opml        → Flux technologie
```

### 2. Backup Automatique
- Exportez chaque mois
- Sauvegardez dans iCloud Drive
- Gardez plusieurs versions

### 3. Import Sélectif
- Exportez par catégorie
- Importez uniquement ce dont vous avez besoin
- Évitez la surcharge de flux

### 4. Partage en Équipe
- Créez des listes thématiques
- Partagez avec votre équipe
- Synchronisez vos sources d'info

---

## 🐛 Résolution de Problèmes / Troubleshooting

### ❌ "No feeds found in OPML file"

**Causes possibles :**
- Fichier OPML vide
- Format invalide
- Pas d'éléments `<outline type="rss">`

**Solution :**
1. Ouvrez le fichier dans un éditeur de texte
2. Vérifiez qu'il contient des éléments `<outline>`
3. Vérifiez que `xmlUrl` est présent

### ❌ "Failed to parse OPML file"

**Causes possibles :**
- Fichier corrompu
- XML mal formé
- Encodage incorrect

**Solution :**
1. Ré-exportez depuis l'app source
2. Vérifiez que c'est bien un fichier `.opml` ou `.xml`
3. Essayez avec un autre fichier OPML

### ❌ "X feeds failed to load"

**Signification :**
- Les flux ont été ajoutés
- Mais impossible de charger les articles immédiatement

**Solution :**
- Normal pour certains flux temporairement indisponibles
- Les flux restent dans votre liste
- Utilisez "Refresh" plus tard pour réessayer

### ⚠️ "X already exist"

**Signification :**
- Ces flux sont déjà dans votre liste
- Pas d'import pour éviter les doublons

**Solution :**
- Aucune action nécessaire
- C'est une protection automatique

---

## 🌍 Compatibilité / Compatibility

### ✅ Compatible avec / Compatible with

| Application | Import | Export |
|-------------|--------|--------|
| Pulse (cette app) | ✅ | ✅ |
| Feedly | ✅ | ✅ |
| NetNewsWire | ✅ | ✅ |
| Reeder | ✅ | ✅ |
| Newsblur | ✅ | ✅ |
| Inoreader | ✅ | ✅ |
| The Old Reader | ✅ | ✅ |
| FeedBin | ✅ | ✅ |

### 📱 Plateformes / Platforms
- ✅ iOS 17+
- ✅ iPadOS 17+
- ✅ macOS 14+ (avec adaptations)

---

## 📊 Statistiques d'Import / Import Statistics

Après chaque import, vous verrez :

```
┌─────────────────────────────────┐
│ Import Complete                 │
├─────────────────────────────────┤
│                                 │
│ 15 feeds imported              │
│ 3 already exist                │
│ 1 failed to load               │
│                                 │
│          [OK]                   │
└─────────────────────────────────┘
```

### Signification
- **Imported** : Nouveaux flux ajoutés avec succès
- **Already exist** : Doublons ignorés
- **Failed to load** : Flux ajoutés mais articles non chargés

---

## 🎓 Exemples Pratiques / Practical Examples

### Exemple 1 : Migration depuis Feedly

```
1. Dans Feedly → Settings → Import/Export → Export OPML
2. Télécharger le fichier (ex: feedly-2026-03-05.opml)
3. Dans Pulse → Gestion → OPML → Import
4. Sélectionner le fichier téléchargé
5. ✅ Tous vos flux Feedly sont maintenant dans Pulse !
```

### Exemple 2 : Backup Mensuel

```
1. Pulse → Gestion → OPML → Export
2. Partager → Fichiers → iCloud Drive
3. Dossier : Documents/Pulse Backups/
4. Répéter chaque mois
5. ✅ Vous avez un historique de vos flux !
```

### Exemple 3 : Partage avec Collègues

```
1. Pulse → Gestion → OPML → Export
2. Renommer : tech-news-feeds.opml
3. Partager → Mail → Envoyer à l'équipe
4. Collègues → Import dans leur lecteur RSS
5. ✅ Toute l'équipe a les mêmes sources !
```

---

## 🔧 Implémentation Technique / Technical Implementation

### Architecture

```
OPMLParser
├── parse(data: Data) → [OPMLFeed]
├── parse(url: URL) → [OPMLFeed]
└── generate(feeds: [RSSFeed]) → String

OPMLManager
├── exportFeeds([RSSFeed]) → String
├── exportToFile([RSSFeed]) → URL
└── importFeeds(from: URL) → ImportResult

OPMLImportExportView
└── SwiftUI interface pour import/export
```

### Fonctionnalités Clés

1. **Parser XML** : Utilise `XMLParser` natif
2. **Évite les doublons** : Compare les URLs des flux
3. **Async/Await** : Import asynchrone pour ne pas bloquer l'UI
4. **Security-Scoped Resources** : Support des fichiers partagés iOS
5. **Error Handling** : Gestion complète des erreurs

---

## 📚 Ressources / Resources

### Documentation OPML
- [OPML Spec 2.0](http://www.opml.org/spec2)
- [OPML on Wikipedia](https://en.wikipedia.org/wiki/OPML)

### Outils en Ligne
- [OPML Validator](http://validator.opml.org/)
- [OPML Reader](http://opml.org/)

---

## ✨ Fonctionnalités Futures / Future Features

Améliorations prévues :

- [ ] Catégories dans OPML (folders)
- [ ] Import partiel (sélectionner les flux)
- [ ] Export automatique planifié
- [ ] Sync iCloud des OPML
- [ ] OPML versionning
- [ ] Import depuis URL directe
- [ ] QR Code pour partage rapide

---

## 🎉 Conclusion

L'import/export OPML est **essentiel** pour :
- 💾 **Sauvegarder** vos flux
- 📱 **Migrer** entre appareils
- 👥 **Partager** avec d'autres
- 🔄 **Changer** de lecteur RSS

**→ Utilisez-le régulièrement ! 🚀**

---

**Créé le :** 05 Mars 2026
**Version :** 1.0
**Langues :** 🇬🇧 English / 🇫🇷 Français
