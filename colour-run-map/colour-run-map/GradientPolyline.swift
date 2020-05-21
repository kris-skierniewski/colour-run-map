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
    enum type {
        case speed
        case altitude
    }
    
    var hues: [CGFloat]?
    public func getHue(from index: Int) -> CGColor {
        return UIColor(hue: (hues?[index])!, saturation: 1, brightness: 1, alpha: 1).cgColor
    }
    
    
    convenience init(locations: [CLLocation], type: GradientPolyline.type) {
        let coordinates = locations.map( { $0.coordinate } )
        self.init(coordinates: coordinates, count: coordinates.count)
        
        let ordered: [CLLocation]
        let maxValue: Double
        let minValue: Double
        
        if type == .speed {
            ordered = locations.sorted(by: { $0.speed > $1.speed })
            maxValue = ordered.first?.speed ?? 5.0
            minValue = ordered.last?.speed ?? 2.0
        } else {
            ordered = locations.sorted(by: { $0.altitude > $1.altitude })
            maxValue = ordered.first?.altitude ?? 1000.0
            minValue = ordered.last?.altitude ?? 0.0
        }
    
        let maxHue = 0.3
        let minHue = 0.03
        
        hues = locations.map({
            let velocity: Double
            if type == .speed {
                velocity = $0.speed
            } else {
                velocity = $0.altitude
            }

            if velocity == maxValue {
                return CGFloat(maxHue)
            }
            
            if velocity == minValue {
                return CGFloat(minHue)
            }

            if minValue < velocity || velocity < maxValue {
                return CGFloat( ( minHue + ( (velocity - minValue) * (maxHue - minHue) ) / (maxValue - minValue) ) )
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
