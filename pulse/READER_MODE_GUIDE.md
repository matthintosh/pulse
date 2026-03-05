# 📖 Guide du Mode Lecture / Reader Mode Guide

## 🎯 Qu'est-ce que le Mode Lecture ? / What is Reader Mode?

Le **Mode Lecture** (Reader Mode) est une fonctionnalité qui affiche les articles dans une interface épurée, optimisée pour la lecture, sans distractions.

**Reader Mode** is a feature that displays articles in a clean, reading-optimized interface without distractions.

---

## ✨ Fonctionnalités / Features

### 📱 Interface Épurée / Clean Interface
- Texte centré et optimisé pour la lecture
- Marges confortables
- Arrière-plan adaptatif (clair/sombre)
- Pas de distractions visuelles

### 🔤 Taille de Police Ajustable / Adjustable Font Size
- 7 tailles disponibles : 14pt à 28pt
- Contrôle facile avec +/-
- Prévisualisation en temps réel
- Réinitialisation rapide

### 🎨 Design Adaptatif / Adaptive Design
- Mode clair : Fond blanc cassé (98%)
- Mode sombre : Fond gris foncé (12%)
- Police serif pour une meilleure lisibilité
- Interligne optimisé

### ⌨️ Sélection de Texte / Text Selection
- Texte sélectionnable
- Copier-coller
- Recherche dans la page
- Définition de mots

---

## 🚀 Comment Utiliser / How to Use

### Ouvrir le Mode Lecture / Open Reader Mode

1. **Ouvrez un article** (tap sur une carte d'article)
2. Dans la barre d'outils en haut, **tap sur l'icône 📄**
3. Le mode lecture s'ouvre en plein écran

### Ajuster la Taille de Police / Adjust Font Size

1. **Dans le mode lecture**, tap sur l'icône 🔤 (textformat.size)
2. Utilisez **-** pour diminuer, **+** pour augmenter
3. Voyez la prévisualisation "Aa" en temps réel
4. Tap **"Reset to Default"** pour revenir à 18pt
5. Tap **"Done"** pour fermer les réglages

### Partager l'Article / Share Article

- Tap sur l'icône **↗️** (partage) dans la barre d'outils
- Choisissez votre méthode de partage

### Fermer le Mode Lecture / Close Reader Mode

- Tap sur **✕** en haut à gauche
- Retour à la vue article normale

---

## 🎨 Caractéristiques de Design / Design Characteristics

### Typographie / Typography

```swift
// Titre / Title
Font: .system(size: fontSize + 8, weight: .bold, design: .serif)
Line spacing: 4pt

// Description
Font: .system(size: fontSize + 2, design: .serif)
Weight: .medium

// Contenu / Content
Font: .system(size: fontSize, design: .serif)
Line spacing: 8pt
```

### Espacement / Spacing

- **Padding horizontal** : 20pt
- **Espacement entre sections** : 24pt
- **Espacement paragraphes** : 16pt
- **Interligne** : 8pt

### Couleurs / Colors

| Mode | Arrière-plan | Texte Principal | Texte Secondaire |
|------|--------------|-----------------|------------------|
| Clair | White 98% | Primary | Secondary |
| Sombre | White 12% | Primary | Secondary |

---

## 💡 Cas d'Usage / Use Cases

### 1. 📚 Lecture Longue / Long Reading
```
Article de 2000+ mots
→ Mode Lecture avec police 20pt
→ Confort de lecture maximal
```

### 2. 👀 Fatigue Visuelle / Eye Strain
```
Lecture prolongée
→ Mode sombre + Police 22pt
→ Réduction de la fatigue
```

### 3. 🎯 Concentration / Focus
```
Article important
→ Mode Lecture (pas de distractions)
→ Meilleure concentration
```

### 4. 📱 Petit Écran / Small Screen
```
iPhone SE
→ Police 16pt pour plus de texte visible
→ Ou 20pt pour plus de confort
```

### 5. 👴 Accessibilité / Accessibility
```
Difficultés de vision
→ Police 24pt ou 28pt
→ Meilleure lisibilité
```

---

## 🎯 Avantages / Advantages

### Pour l'Utilisateur / For User

✅ **Confort**
- Police serif optimisée pour la lecture
- Interligne généreux
- Marges confortables

✅ **Personnalisation**
- 7 tailles de police
- Adaptation au mode clair/sombre
- Préférences sauvegardées

✅ **Focus**
- Pas de distractions visuelles
- Contenu centré
- Interface minimaliste

✅ **Accessibilité**
- Texte sélectionnable
- Grande police disponible
- Contraste optimisé

### Pour le Développeur / For Developer

✅ **Simple**
- Une vue SwiftUI
- Pas de dépendances
- Code propre et maintenable

✅ **Performant**
- Rendering optimisé
- Pas de WebView lourde
- Expérience fluide

✅ **Extensible**
- Facile d'ajouter des options
- Personnalisation possible
- Architecture modulaire

---

## 🔧 Implémentation Technique / Technical Implementation

### Architecture

```
ReaderModeView (Main View)
├── Header Section
│   ├── Feed name
│   ├── Publication date
│   └── Article title
├── Content Section
│   ├── Description
│   └── Main content
└── Toolbar
    ├── Close button
    ├── Settings button
    └── Share button

ReaderSettingsView (Settings Sheet)
├── Font size control
│   ├── Decrease button (-)
│   ├── Preview (Aa)
│   └── Increase button (+)
└── Reset button
```

### État / State Management

```swift
@State private var fontSize: CGFloat = 18
@State private var showSettings = false
```

### Tailles de Police / Font Sizes

```swift
private let fontSizes: [CGFloat] = [14, 16, 18, 20, 22, 24, 28]
```

### Couleur d'Arrière-plan Adaptive / Adaptive Background

```swift
private var readerBackground: Color {
    colorScheme == .dark ? Color(white: 0.12) : Color(white: 0.98)
}
```

---

## 📱 Expérience Utilisateur / User Experience

### Flow Complet / Complete Flow

```
1. User ouvre article
   ↓
2. Lit l'aperçu avec images/formatage
   ↓
3. Décide de lire en mode lecture
   ↓
4. Tap sur icône Reader Mode 📄
   ↓
5. Vue plein écran avec texte épuré
   ↓
6. Ajuste la taille si nécessaire
   ↓
7. Lit confortablement
   ↓
8. Ferme avec ✕ quand terminé
```

### Interactions / Interactions

| Action | Geste | Résultat |
|--------|-------|----------|
| Ouvrir | Tap 📄 | Fullscreen Reader |
| Réglages | Tap 🔤 | Sheet avec options |
| Augmenter | Tap + | Font +1 step |
| Diminuer | Tap - | Font -1 step |
| Reset | Tap button | Font = 18pt |
| Partager | Tap ↗️ | Share sheet |
| Fermer | Tap ✕ ou swipe down | Retour article |

---

## 🎓 Bonnes Pratiques / Best Practices

### Pour l'Utilisateur / For User

1. **Commencez avec la taille par défaut** (18pt)
2. **Ajustez selon votre confort** et la longueur de l'article
3. **Utilisez le mode sombre** pour la lecture nocturne
4. **Profitez de la sélection de texte** pour prendre des notes

### Pour le Développeur / For Developer

1. **Police serif** pour la lisibilité
2. **Interligne généreux** (8pt minimum)
3. **Marges confortables** (20pt minimum)
4. **Contraste élevé** entre texte et fond
5. **Texte sélectionnable** pour l'accessibilité

---

## 🆚 Comparaison avec Safari Reader / Comparison with Safari Reader

| Fonctionnalité | Pulse Reader Mode | Safari Reader |
|----------------|-------------------|---------------|
| Plein écran | ✅ | ✅ |
| Taille de police | ✅ 7 tailles | ✅ Variable |
| Mode sombre | ✅ Auto | ✅ Manuel |
| Texte sélectionnable | ✅ | ✅ |
| Police serif | ✅ | ✅ |
| Offline | ✅ Toujours | ⚠️ Cache |
| Instantané | ✅ Natif | ⚠️ Parsing |
| Images | ❌ Texte seul | ✅ |
| Formatage | ❌ Plain text | ✅ Préservé |

### Avantages Pulse / Pulse Advantages

- ✅ **Plus rapide** (pas de parsing HTML)
- ✅ **Toujours disponible** (offline)
- ✅ **Design cohérent** avec l'app
- ✅ **Contrôle total** sur l'expérience

### Avantages Safari / Safari Advantages

- ✅ **Images préservées**
- ✅ **Formatage original**
- ✅ **Liens interactifs**

---

## 🚀 Améliorations Futures / Future Enhancements

### Court Terme / Short Term
- [ ] Sauvegarde de la préférence de taille de police
- [ ] Plus d'options de police (sans-serif, monospace)
- [ ] Thèmes de couleur personnalisés
- [ ] Surlignage de texte

### Moyen Terme / Medium Term
- [ ] Synchronisation de position de lecture
- [ ] Marque-pages dans l'article
- [ ] Notes et annotations
- [ ] Export en PDF

### Long Terme / Long Term
- [ ] Text-to-speech (lecture audio)
- [ ] Traduction intégrée
- [ ] Résumé IA
- [ ] Questions/réponses sur l'article

---

## 📊 Statistiques de Lisibilité / Readability Statistics

### Taille de Police Recommandée / Recommended Font Size

| Appareil | Distance | Taille Recommandée |
|----------|----------|-------------------|
| iPhone | 30-40cm | 18-20pt |
| iPad | 40-50cm | 20-22pt |
| Vision faible | Variable | 24-28pt |

### Longueur de Ligne Optimale / Optimal Line Length

- **Caractères par ligne** : 50-75 (optimal 66)
- **Mots par ligne** : 10-12
- **Padding horizontal** : 20pt minimum

---

## 🎨 Personnalisation / Customization

### Modifier les Tailles Disponibles / Modify Available Sizes

```swift
private let fontSizes: [CGFloat] = [14, 16, 18, 20, 22, 24, 28]
// Ajoutez/supprimez des tailles selon vos besoins
```

### Changer la Taille par Défaut / Change Default Size

```swift
@State private var fontSize: CGFloat = 18 // Changez cette valeur
```

### Personnaliser les Couleurs / Customize Colors

```swift
private var readerBackground: Color {
    colorScheme == .dark 
        ? Color(white: 0.12)  // Changez ici pour le mode sombre
        : Color(white: 0.98)  // Changez ici pour le mode clair
}
```

### Modifier l'Interligne / Modify Line Spacing

```swift
.lineSpacing(8) // Augmentez pour plus d'espace
```

---

## 📚 Ressources / Resources

### Documentation Apple
- [Typography - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/typography)
- [Text - SwiftUI](https://developer.apple.com/documentation/swiftui/text)
- [Font - SwiftUI](https://developer.apple.com/documentation/swiftui/font)

### Best Practices
- [Web Typography](https://betterwebtype.com/)
- [Practical Typography](https://practicaltypography.com/)
- [The Elements of Typographic Style](https://en.wikipedia.org/wiki/The_Elements_of_Typographic_Style)

---

## ✨ Conclusion

Le **Mode Lecture** offre une expérience de lecture **optimale** :
- 📖 **Confort visuel** maximal
- 🎯 **Concentration** améliorée
- ♿ **Accessibilité** renforcée
- ⚡ **Performance** native

**Utilisez-le pour tous vos articles longs ! 📚**

---

**Créé le :** 05 Mars 2026
**Version :** 1.0
**Langues :** 🇬🇧 English / 🇫🇷 Français
**Status :** ✅ Implémenté et Testé
