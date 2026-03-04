//
//  ArticleWebView.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI
import SafariServices

struct ArticleWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true // Active le mode lecture automatiquement
        configuration.barCollapsingEnabled = true
        
        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        safariVC.preferredControlTintColor = .systemBlue
        safariVC.dismissButtonStyle = .close
        
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Pas besoin de mettre à jour
    }
}

#Preview {
    ArticleWebView(url: URL(string: "https://www.apple.com")!)
}
