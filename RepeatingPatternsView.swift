//
//  RepeatingPatternsView.swift
//  FunWithShapes
//
//  Created by Derek Howes on 3/28/23.
//

import SwiftUI
import PureSwiftUI

private let gridLayoutConfig = LayoutGuideConfig.grid(columns: 16, rows: 20)
private typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

struct RepeatingPatternsView: View {
    @State private var heatBeating: Bool = false
    
    var body: some View {
        VStack(spacing: 50) {
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

struct RepeatingPatternsView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatingPatternsView()
            .showLayoutGuides(true)
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
        
        var g = gridLayoutConfig.layout(in: rect)
            .scaled(0.4)
            .yOffset(rect.heightScaled(-0.3))
        
        for _ in 0..<4 {
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
            
            g = g.rotated(90.degrees)
        }
        
        return path
    }
}
