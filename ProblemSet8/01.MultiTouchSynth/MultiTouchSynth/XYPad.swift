//
//  XYPad.swift
//  MultiTouchSynth
//
//  Created by Noah Leong on 3/29/21.
//

import SwiftUI
import AudioKit

class XYPad: UIView {
    let screenSize = UIScreen.main.bounds
    let circleSize:CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isMultipleTouchEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
        isMultipleTouchEnabled = true
    }
    
 
    // Add circle to this view based the touch position
    // NOTE: This is not the best way to draw something in iOS, but the code is easier to understand
    func addCircle(point: CGPoint){
        // Create a new UIView based on incoming the touch position
        let circle = UIView(frame: CGRect(x: point.x - circleSize/2, y: point.y - circleSize/2, width: circleSize, height: circleSize))
        // Set the color for the circle
        circle.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
        // Increment color variable
        // Set the corner radius to make the view into circle shape
        circle.layer.cornerRadius = circleSize / 2
        circle.clipsToBounds = true
        self.addSubview(circle)
    }
}
