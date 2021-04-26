//
//  CanvasView.swift
//  DigitClassifierApp
//
//  Created by Doyun Kim on 4/22/21.
// Reference: https://letcreateanapp.com/2020/12/29/swift-5-1-how-to-make-drawing-app/

import UIKit

// The original tutorial supports different color and storke size.
// BUT I fix the color and stroke size to make the drawing look like the original MNIST dataset.
struct TouchPointsAndColor {
    var color: UIColor?
    var width: CGFloat?
    var opacity: CGFloat?
    var points: [CGPoint]?
    
    init(color: UIColor, points: [CGPoint]?) {
        self.color = color
        self.points = points
    }
}

class CanvasView: UIView {
    
    // Drawing consists of a set of lines
    // each line consists of a set of points made by touch move.
    var lines = [TouchPointsAndColor]()

    // Default line properties.
    // Remember the white color has higher value than black color.
    // So we draw white lines in black background to match the number system with MNIST model.
    var strokeWidth: CGFloat = 30.0
    var strokeColor: UIColor = .white
    var strokeOpacity: CGFloat = 1.0
    
    // UIView's method to redraw contents within its bound.
    // Called by setNeedsDisplay() method below.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // draw each line using Core Graphic Context.
        lines.forEach { (line) in
            for (idx, point) in (line.points?.enumerated())! {
                if idx == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
                context.setStrokeColor(line.color?.withAlphaComponent(line.opacity ?? 1.0).cgColor ?? UIColor.white.cgColor)
                context.setLineWidth(line.width ?? 30.0)
            }
            context.setLineCap(.round)
            context.strokePath()
        }
    }
    
    
    // MARK: override methods to handle touch (drawing)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Start to draw a new line
        lines.append(TouchPointsAndColor(color: UIColor(), points: [CGPoint]()))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // NOTE: location must be set to self to get the coordinate of Canvas view.
        guard let touch = touches.first?.location(in: self) else {
            return
        }
        
        // Take the last line we were drawing and append new touch points.
        guard var lastPoint = lines.popLast() else {return}
        lastPoint.points?.append(touch)
        lastPoint.color = strokeColor
        lastPoint.width = strokeWidth
        lastPoint.opacity = strokeOpacity
        lines.append(lastPoint)
        setNeedsDisplay()
    }
    

    // MARK: the corressponding methods to buttons.
    
    func getUIImageFromDrawing() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
    
    func clearCanvasView() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func undoDraw() {
        if lines.count > 0 {
            lines.removeLast()
            setNeedsDisplay()
        }
    }

}
