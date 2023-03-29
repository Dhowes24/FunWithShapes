//
//  ContentView.swift
//  FunWithShapes
//
//  Created by Derek Howes on 3/27/23.
//

import SwiftUI
import PureSwiftUI
private let innerRadiusRatio: CGFloat = 0.4
private let strokeStyle = StrokeStyle(lineWidth: 1, lineJoin: .round)
private let starlayoutConfig = LayoutGuideConfig.polar(rings: [0, innerRadiusRatio, 1], segments: 30)


struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let g = starlayoutConfig.layout(in: rect)
        
        path.move(g[2,0])
        
        for segment in 1..<g.yCount {
            path.line(g[segment.isOdd ? 1 : 2, segment])
        }
        
        path.closeSubpath()
        
        return path
    }
}

struct Polygon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let g = starlayoutConfig.layout(in: rect)
        
        path.move(g[2,0])
        
        for segment in 1..<g.yCount {
            path.line(g[2, segment])
        }
        
        path.closeSubpath()
        
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let g = LayoutGuideConfig.polar(rings: [0, 1], segments: 3).layout(in: rect)
        
        path.move(g[2,0])
        
        for segment in 1..<g.yCount {
            path.line(g[2, segment])
        }
        
        path.closeSubpath()
        
        return path
    }
}

struct PolarLayoutView: View {
    var body: some View {
        VStack {
            Star()
                .stroke(style: strokeStyle)
                .frame(250)
                .layoutGuide(starlayoutConfig)
            Polygon()
                .stroke(style: strokeStyle)
                .frame(250)
                .layoutGuide(starlayoutConfig)
            Triangle()
                .stroke(style: strokeStyle)
                .frame(250)
                .layoutGuide(LayoutGuideConfig.polar(rings: [0, 1], segments: 3))
            
        }
        .padding()
    }
}

struct PolarLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        PolarLayoutView()
            .showLayoutGuides(true)
    }
}
