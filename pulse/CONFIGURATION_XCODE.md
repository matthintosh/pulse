# 🛠️ Configuration de la Localisation dans Xcode / Xcode Localization Setup

## Étape par étape / Step by Step

### 1️⃣ Ajouter le fichier Localizable.xcstrings au projet

Si le fichier n'est pas encore dans votre projet :

1. Dans Xcode, faites un clic droit sur votre dossier de projet
2. Sélectionnez "Add Files to [nom du projet]..."
3. Sélectionnez `Localizable.xcstrings`
4. Cochez "Copy items if needed"
5. Assurez-vous que le target de votre app est coché
6. Cliquez sur "Add"

### 2️⃣ Configurer les langues du projet / Configure Project Languages

1. **Sélectionnez le projet** dans le navigateur (fichier bleu en haut)
2. Dans la section **PROJECT** (pas TARGET), sélectionnez votre projet
3. Allez dans l'onglet **Info**
4. Trouvez la section **Localizations**
5. Vous devriez voir :
   - ✅ English - Development Language
   - ✅ French (si pas présent, cliquez sur + et ajoutez-le)

```
┌─────────────────────────────────┐
│ Localizations                   │
├─────────────────────────────────┤
│ English (en) - Development     │
│ French (fr)                    │
│ [+] [-]                        │
└─────────────────────────────────┘
```

### 3️⃣ Vérifier le fichier Localizable.xcstrings

1. Cliquez sur `Localizable.xcstrings` dans le navigateur
2. Xcode devrait l'ouvrir avec l'**éditeur de String Catalog**
3. Vous verrez une table avec :
   - **Key** : La clé en anglais
   - **English** : La traduction anglaise
   - **French** : La traduction française
   - **Comment** : Le contexte pour les traducteurs

```
┌────────────────────────────────────────────────────────┐
│ Key                │ English        │ French           │
├────────────────────────────────────────────────────────┤
│ Welcome to Pulse   │ Welcome...     │ Bienvenue...     │
│ Add Feed           │ Add Feed       │ Ajouter un flux  │
│ ...                │ ...            │ ...              │
└────────────────────────────────────────────────────────┘
```

### 4️⃣ Tester avec différentes langues / Test with Different Languages

#### Option A : Changer le schéma de l'application

1. Dans Xcode, allez dans **Product** → **Scheme** → **Edit Scheme...**
2. Sélectionnez **Run** dans la barre latérale
3. Allez dans l'onglet **Options**
4. Trouvez **App Language**
5. Sélectionnez :
   - `System Language` (langue du système)
   - `English` (pour forcer l'anglais)
   - `French` (pour forcer le français)
6. Cliquez sur **Close**
7. **Lancez l'application** (⌘R)

```
Edit Scheme
├── Build
├── Run ◄── Sélectionner
│   ├── Info
│   ├── Arguments
│   └── Options ◄── Cliquer ici
│       └── App Language: [French ▼]
├── Test
└── ...
```

#### Option B : Changer la langue du simulateur

1. Lancez le simulateur iOS
2. Ouvrez **Settings** (Réglages)
3. Allez dans **General** → **Language & Region**
4. Touchez **iPhone Language**
5. Sélectionnez **Français** (ou autre)
6. Confirmez et attendez le redémarrage
7. Relancez votre application

### 5️⃣ Vérifier les traductions dans le code / Check Translations in Code

Assurez-vous que votre code utilise les bonnes méthodes :

#### ✅ Correct - Avec localisation

```swift
// Pour Text views
Text("Welcome to Pulse", bundle: .main, comment: "Welcome title")

// Pour String
let message = String(localized: "Add Feed", comment: "Button label")

// Pour Label
Label(String(localized: "Share", comment: "Share action"), systemImage: "square.and.arrow.up")
```

#### ❌ Incorrect - Sans localisation

```swift
// Ne sera PAS traduit
Text("Welcome to Pulse")

// Ne sera PAS traduit
let message = "Add Feed"

// Ne sera PAS traduit
Label("Share", systemImage: "square.and.arrow.up")
```

### 6️⃣ Ajouter de nouvelles traductions / Add New Translations

#### Dans l'éditeur Xcode

1. Ouvrez `Localizable.xcstrings`
2. Cliquez sur **+** en bas à gauche
3. Entrez la **clé** (texte en anglais)
4. Appuyez sur **Enter**
5. Remplissez les colonnes English et French
6. Ajoutez un **commentaire** pour expliquer le contexte

#### Dans le code JSON

Ajoutez manuellement dans le fichier :

```json
"Your New Key" : {
  "comment" : "Description du contexte",
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Your New Key"
      }
    },
    "fr" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Votre Nouvelle Clé"
      }
    }
  }
}
```

### 7️⃣ Exporter pour traduction professionnelle / Export for Professional Translation

Si vous voulez faire traduire par un professionnel :

1. Dans Xcode : **Product** → **Export Localizations...**
2. Sélectionnez les langues à exporter
3. Choisissez un dossier de destination
4. Cliquez sur **Export**
5. Vous obtiendrez des fichiers `.xcloc` que vous pouvez envoyer aux traducteurs
6. Après traduction : **Product** → **Import Localizations...**

### 8️⃣ Vérifier les traductions manquantes / Check for Missing Translations

1. Ouvrez `Localizable.xcstrings` dans Xcode
2. Regardez les icônes dans la colonne de gauche :
   - ✅ **Vert** = Traduit
   - ⚠️ **Jaune** = Manquant ou à réviser
   - ❌ **Rouge** = Erreur

3. Filtrez les traductions :
   - En haut à droite, utilisez le filtre
   - Sélectionnez **Needs Review** pour voir ce qui doit être vérifié

### 9️⃣ Bonnes pratiques / Best Practices

#### ✅ À faire / Do

- Toujours ajouter un commentaire explicatif
- Utiliser des clés descriptives en anglais
- Tester dans toutes les langues avant de publier
- Utiliser `String(localized:)` pour les strings programmées
- Ajouter des traductions au fur et à mesure du développement

#### ❌ À éviter / Don't

- Ne pas concaténer des textes localisés
- Ne pas utiliser de texte hardcodé sans localisation
- Ne pas oublier de localiser les messages d'erreur
- Ne pas utiliser des clés génériques comme "text1", "button2"
- Ne pas traduire les noms de marque ou termes techniques spécifiques

### 🔟 Problèmes courants et solutions / Common Issues and Solutions

#### Problème : Les traductions n'apparaissent pas

**Solution :**
1. Vérifiez que `Localizable.xcstrings` est dans le target
2. Clean Build Folder (⇧⌘K)
3. Rebuild le projet (⌘B)
4. Relancez l'application

#### Problème : Xcode ne détecte pas les nouvelles clés

**Solution :**
1. Fermez et rouvrez `Localizable.xcstrings`
2. Redémarrez Xcode si nécessaire
3. Vérifiez la syntaxe JSON si édité manuellement

#### Problème : Les textes sont coupés dans une langue

**Solution :**
1. Utilisez `.fixedSize(horizontal: false, vertical: true)` pour le texte
2. Testez les layouts avec des textes longs
3. Ajustez les contraintes et paddings si nécessaire
4. Le français est souvent 20-30% plus long que l'anglais

#### Problème : Erreur de compilation avec String(localized:)

**Solution :**
- `String(localized:)` nécessite iOS 15+, macOS 12+
- Vérifiez votre **Deployment Target** dans les réglages du projet
- Pour des versions plus anciennes, utilisez `NSLocalizedString`

### 📱 Tester sur différents appareils / Test on Different Devices

#### Simulateurs recommandés :
- iPhone 15 Pro (écran standard)
- iPhone 15 Pro Max (grand écran)
- iPhone SE (petit écran) - important pour les textes longs !
- iPad Pro (pour vérifier les adaptations)

#### Langues à tester :
1. **Anglais** : Langue de référence
2. **Français** : Textes généralement plus longs
3. **Allemand** (si ajouté) : Mots composés très longs
4. **Japonais** (si ajouté) : Caractères plus grands
5. **Arabe** (si ajouté) : Direction RTL (droite à gauche)

### 🎯 Checklist avant publication / Pre-Release Checklist

- [ ] Toutes les chaînes sont traduites (pas de ⚠️)
- [ ] Tests effectués dans toutes les langues
- [ ] Layouts vérifiés sur petit écran (iPhone SE)
- [ ] Messages d'erreur tous localisés
- [ ] Commentaires ajoutés pour chaque clé
- [ ] Métadonnées App Store localisées
- [ ] Captures d'écran dans chaque langue
- [ ] Description App Store traduite
- [ ] Notes de version traduites

### 📚 Ressources supplémentaires / Additional Resources

- [Apple Documentation - Localization](https://developer.apple.com/localization/)
- [String Catalogs Guide](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
- [WWDC Videos on Localization](https://developer.apple.com/videos/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

✨ **Bonne chance avec votre localisation !** / **Good luck with your localization!**

N'hésitez pas à consulter le [Guide de Localisation](LOCALIZATION_README.md) pour plus de détails sur l'utilisation dans le code.
