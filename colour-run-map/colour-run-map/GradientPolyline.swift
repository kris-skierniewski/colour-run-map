//
//  GradientPolyline.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 13/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import MapKit

class GradientPolyline: MKPolyline {
    var hues: [CGFloat]?
    public func getHue(from index: Int) -> CGColor {
        return UIColor(hue: (hues?[index])!, saturation: 1, brightness: 1, alpha: 1).cgColor
    }
    
    
    convenience init(locations: [CLLocation]) {
        let coordinates = locations.map( { $0.coordinate } )
        self.init(coordinates: coordinates, count: coordinates.count)
        
        let ordered = locations.sorted(by: { $0.speed > $1.speed })

        let maxSpeed: Double = ordered.first?.speed ?? 5.0
        let minSpeed = ordered.last?.speed ?? 2.0
        let maxHue = 0.3
        let minHue = 0.03

//        hues = [
//            0.03,
//            0.04,
//            0.05,
//            0.06,
//            0.07,
//            0.08,
//            0.09,
//            0.1,
//            0.15,
//            0.26,
//            0.26,
//            0.27,
//            0.28,
//            0.29,
//            0.3,
//            0.3
//
//        ]
        
        hues = locations.map({
            let velocity: Double = $0.speed

            if velocity == maxSpeed {
                return CGFloat(maxHue)
            }
            
            if velocity == minSpeed {
                return CGFloat(minHue)
            }

            if minSpeed < velocity || velocity < maxSpeed {
                return CGFloat( ( minHue + ( (velocity - minSpeed) * (maxHue - minHue) ) / (maxSpeed - minSpeed) ) )
            }
            
            return CGFloat(velocity)
        })
    }
    
    
}

class GradientPolylineRenderer: MKPolylineRenderer {

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        if let path = self.path {
            let boundingBox = path.boundingBox
            let mapRectCG = rect(for: mapRect)

            if(!mapRectCG.intersects(boundingBox)) { return }


            var prevColor: CGColor?
            var currentColor: CGColor?

            guard let polyLine = self.polyline as? GradientPolyline else { return }

            for index in 0...self.polyline.pointCount - 1{
                let point = self.point(for: self.polyline.points()[index])
                let path = CGMutablePath()


                currentColor = polyLine.getHue(from: index)

                if index == 0 {
                   path.move(to: point)
                } else {
                    let prevPoint = self.point(for: self.polyline.points()[index - 1])
                    path.move(to: prevPoint)
                    path.addLine(to: point)

                    let colors = [prevColor!, currentColor!] as CFArray
                    let baseWidth = self.lineWidth / zoomScale

                    context.saveGState()
                    context.addPath(path)

                    let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0, 1])

                    context.setLineWidth(baseWidth)
                    context.replacePathWithStrokedPath()
                    context.clip()
                    context.drawLinearGradient(gradient!, start: prevPoint, end: point, options: [])
                    context.restoreGState()
                }
                prevColor = currentColor
            }
        }
    }
}
