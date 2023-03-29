//
//  AdvancedShapeDesignView.swift
//  FunWithShapes
//
//  Created by Derek Howes on 3/28/23.
//

import SwiftUI
import PureSwiftUI

private let heartLayoutConfig = LayoutGuideConfig.grid(columns: 8, rows: 10)

private typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

struct Heart: Shape {
    let debug: Bool
    init(debug: Bool = false) {
        self.debug = debug
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let g = heartLayoutConfig.layout(in: rect)
        
        let p1 = g[0,3]
        let p2 = g[4,2]
        let p3 = g[8,3]
        let p4 = g[4,10]
        
        var curves = [Curve]()
        //c1
        curves.append(
            Curve(p2,
                  g[0,0],
                  g[3,-1]))
        //c2
        curves.append(
            Curve(p3,
                  g[5,-1],
                  g[8,0]))
        
        //c3
        curves.append(
            Curve(p4,
                  g[8,6],
                  g[4,7]))
        
        //c4
        curves.append(
            Curve(p1,
                  g[4,7],
                  g[0,6]))
        
        path.move(p1)
        
        for curve in curves {
            path.curve(curve.p, cp1: curve.cp1, cp2: curve.cp2, showControlPoints: debug)
        }
        return path
    }
}

struct BezierCurvesView: View {
    var body: some View {
        VStack{
            ZStack {
                
                Heart()
                    .fill(Color.red)
                    .frame(350)

                
                Heart(debug: true)
                    .stroke(Color.black, lineWidth: 2)
                    .layoutGuide(heartLayoutConfig)
                    .frame(350)
            }
        }
    }
}

struct BezierCurvesView_Previews: PreviewProvider {
    static var previews: some View {
        BezierCurvesView()
            .showLayoutGuides(true)
    }
}
