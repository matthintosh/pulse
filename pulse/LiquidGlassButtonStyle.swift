//
//  LiquidGlassButtonStyle.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI

struct LiquidGlassButtonStyle: ButtonStyle {
    var isProminent: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == LiquidGlassButtonStyle {
    static var liquidGlass: LiquidGlassButtonStyle {
        LiquidGlassButtonStyle()
    }
    
    static var liquidGlassProminent: LiquidGlassButtonStyle {
        LiquidGlassButtonStyle(isProminent: true)
    }
}
