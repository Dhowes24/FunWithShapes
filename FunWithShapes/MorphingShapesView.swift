//
//  MorphingShapesView.swift
//  FunWithShapes
//
//  Created by Derek Howes on 3/28/23.
//

import SwiftUI
import PureSwiftUI

private let strokeStyle = StrokeStyle(lineWidth: 2, lineJoin: .round)
private let shoulderRatio: CGFloat = 0.65
private let arrowLayoutConfig = LayoutGuideConfig.grid(columns: [0, 1 - shoulderRatio, shoulderRatio, 1], rows: 3)

private let gridLayoutConfig = LayoutGuideConfig.grid(columns: 16, rows: 20)
private typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

private struct Arrow: Shape {
    
    private var factor: Double
    
    
    init(pointRight: Bool = true) {
        self.factor = pointRight ? 0: 1
    }
    
    var animatableData: Double {
        get {
            factor
        }
        set {
            factor = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let g = arrowLayoutConfig.layout(in: rect)
        
        path.move(g[0,1].to(g[1,0], factor))
        path.line(g[2,1].to(g[1, 1], factor))
        path.line(g[2,0].to(g[3, 1], factor))
        path.line(g.trailing)
        path.line(g[2,3].to(g[3, 2], factor))
        path.line(g[2,2].to(g[1, 2], factor))
        path.line(g[0,2].to(g[1, 3], factor))
        path.line(g.leading)
        
        path.closeSubpath()
        return path
    }
}

private struct HeartBeat: Shape {
    private var factor: CGFloat
    
    init(beating: Bool = false) {
        self.factor = beating ? 0: 1
    }
    
    var animatableData: CGFloat {
         get {
             factor
         }
         set {
             factor = newValue
         }
     }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let g = gridLayoutConfig.layout(in: rect)
        
        let p1 = g[0,6].to(g[2,6], factor)
        let p2 = g[8,4].to(g[8,5], factor)
        let p3 = g[16,6].to(g[14,6], factor)
        let p4 = g[8,20].to(g[8,19], factor)
        
        var curves = [Curve]()
        //c1
        curves.append(
            Curve(p2,
                  g[0,0].to(g[3,2], factor),
                  g[6,-2].to(g[7,2], factor)))
        //c2
        curves.append(
            Curve(p3,
                  g[10,-2].to(g[9,2], factor),
                  g[16,0].to(g[13,2], factor)))
        
        //c3
        curves.append(
            Curve(p4,
                  g[16,10].to(g[15,10], factor),
                  g[10,13]))
        
        //c4
        curves.append(
            Curve(p1,
                  g[6,13],
                  g[0,10].to(g[1,10], factor)))
        
        path.move(p1)
        
        for curve in curves {
            path.curve(curve.p, cp1: curve.cp1, cp2: curve.cp2, showControlPoints: true)
        }
        return path
    }
}

struct MorphingShapesView: View {
    @State private var pointRight: Bool = true
    @State private var heatBeating: Bool = false
    
    var body: some View {
        VStack(spacing: 50) {
            Arrow(pointRight: pointRight)
                .fillColor(.black)
                .layoutGuide(arrowLayoutConfig)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        pointRight.toggle()
                    }
                }
                .frame(300)
            HeartBeat(beating: heatBeating)
                .stroke(.red, lineWidth: 4)
                .layoutGuide(gridLayoutConfig)
                .onAppear {
                    withAnimation(
                        Animation.easeOut(duration:0.8)
                            .repeatForever(autoreverses: true)) {
                                self.heatBeating = true
                            }
                }
                .frame(300)
            
        }
    }
}

struct MorphingShapesView_Previews: PreviewProvider {
    static var previews: some View {
        MorphingShapesView()
            .showLayoutGuides(true)
    }
}
