//
//  ContentView.swift
//  TurnItUp
//
//  Created by me on 22.12.2024.
//

import SwiftUI

struct StretchySlider: View {
    private let startProgress: CGFloat = 0.5
    private let limit = 0.1
    private let recRadius: CGFloat = 20
    private let scaleEffect: CGFloat = 0.15
    
    @State private var progress: CGFloat = 0.5
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = 200 / 2
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let volumeHeight = size.height
            let progressValue = max(progress, .zero) * volumeHeight
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Rectangle()
                    .fill(.white)
                    .frame(width: size.width, height: progressValue)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: recRadius))
            .contentShape(RoundedRectangle(cornerRadius: recRadius))
            .frame(height: progress < 0 ? volumeHeight + (-progress * volumeHeight) : nil)
            .scaleEffect(
                x: progress > 1 ? (1 - (progress - 1) * scaleEffect) : (progress < 0) ? (1 + progress * scaleEffect) : 1
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { evt in
                        dragOffset = -evt.translation.height + lastDragOffset
                        calcProgress(volumeHeight: volumeHeight)
                    }
                    .onEnded { _ in
                        withAnimation(.smooth) {
                            dragOffset = startProgress * volumeHeight
                            progress = startProgress
                        }
                        
                        lastDragOffset = dragOffset
                    }
                    
            )
            .frame(
                maxWidth: size.width,
                maxHeight: size.height,
                alignment: progress < 0 ? .top : .bottom
            )
        }
    }
    
    private func calcProgress(volumeHeight: CGFloat) {
        let topOffset = volumeHeight + (dragOffset - volumeHeight) * 0.1
        let bottomOffset = dragOffset < 0 ? dragOffset * 0.1 : dragOffset
        let progress = (dragOffset > volumeHeight ? topOffset : bottomOffset) / volumeHeight
        
        self.progress = progress < 0 ? (-progress > limit ? -limit : progress) : (progress > (1.0 + limit) ? (1.0 + limit) : progress)
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("wallpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            StretchySlider()
                .frame(width: 80, height: 200)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
