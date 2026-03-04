//
//  AppIconPreview.swift
//  pulse
//
//  Created by Matthieu Rocher on 03/03/2026.
//

import SwiftUI

struct AppIconPreview: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.8),
                    Color(red: 0.4, green: 0.2, blue: 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Pulse waves
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 3)
                    .frame(width: 280, height: 280)
                
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 3)
                    .frame(width: 360, height: 360)
            }
            
            // Center symbol
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 180, height: 180)
                    .glassEffect(.regular, in: .circle)
                
                Image(systemName: "wave.3.right")
                    .font(.system(size: 80, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview {
    AppIconPreview()
}
