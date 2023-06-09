//
//  TransformingAndAnimatingLayoutGuidesView.swift
//  FunWithShapes
//
//  Created by Derek Howes on 3/28/23.
//
//https://www.youtube.com/watch?v=PI-2vyBfpoQ

import SwiftUI
import PureSwiftUI

private let polarLayoutGuide = LayoutGuideConfig.polar(rings: 1, segments: 3)
private let gridLayoutGuide = LayoutGuideConfig.grid(columns: 3, rows: 3)
private let demoStrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)

struct TransformingAndAnimatingLayoutGuidesView: View {
    @State private var animated = false
    
    var body: some View {
        VStack(spacing: 50){
            Group {
//                AnimatedPolarShape(animating: animated)
//                    .demoStyle()
//                    .layoutGuide(polarLayoutGuide)
                AnimatedGridShape(animating: animated)
                    .demoStyle()
                    .layoutGuide(gridLayoutGuide)
            }
            .frame(200)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(Animation.easeInOut(duration: 1.5)) {
                animated.toggle()
            }
        }
    }
}

private extension Shape {
    func demoStyle() -> some View {
        stroke(Color.white, style:demoStrokeStyle)
    }
}

private struct AnimatedPolarShape: Shape {
    
    var animatableData: Double
    
    init(animating: Bool) {
        self.animatableData = animating ? 0 : 1
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var g = polarLayoutGuide.layout(in: rect)
            .rotated(from: -360.degrees, to: 170.degrees ,factor: animatableData)
            //Scale ratio to make rolling not slipping
            .scaled(1 / Double.pi)
            .xOffset(from: -rect.halfWidth, to: rect.halfWidth, factor: animatableData)
        
        let transformedHeight: CGFloat = g.bottom.radiusTo(g.top)
        
        g = g.yOffset(-transformedHeight * 0.5)
        
        path.line(from: rect.leading, to: rect.trailing)
        
        path.ellipse(g.center, .square(transformedHeight), anchor: .center)
        
        for segment in 0..<g.yCount {
            path.line(from:g.center, to: g[1, segment])
        }
        
        return path
    }
}

private struct AnimatedGridShape: Shape {
    var animatableData: Double
    
    init(animating: Bool) {
        self.animatableData = animating ? 1 : 0
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var g = gridLayoutGuide.layout(in: rect)
            .rotated(360.degrees, factor: animatableData)
        
        for corner in 0..<4 {
            
            var localG = g.rotated(90.degrees * corner)
            if corner == 0 {
                path.move(localG.top)
            }
            path.line(localG[2,0])
            path.line(localG[3,0].to(localG[2,1], animatableData))
            path.line(localG[3,1])
            path.line(localG.trailing)
        }
        
        return path
    }
}

struct TransformingAndAnimatingLayoutGuidesView_Previews: PreviewProvider {
    struct TransformingAndAnimatingLayoutGuidesView_Harness: View {
        
        var body: some View {
            TransformingAndAnimatingLayoutGuidesView()
                .greedyFrame()
                .background(Color(white: 0.1))
                .ignoresSafeArea()
                .showLayoutGuides(true)
        }
    }
    
    static var previews: some View {
        TransformingAndAnimatingLayoutGuidesView_Harness()
    }
}
