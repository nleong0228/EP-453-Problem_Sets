//
//  ChorusController.swift
//  MultiTouchChorus
//
//  Created by Noah Leong on 3/29/21.
//

import UIKit
import SwiftUI

class ChorusController: UIViewController {
    static let numFingers = 10
    var fingers = [UITouch:CGPoint]()
    let synth = MultiTouchSynth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = ChorusView(frame: .zero)
    }

    override func viewDidAppear(_ animated: Bool) {
        synth.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        synth.stop()
    }
    
    // MARK: - Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if fingers[touch] == nil {
                var location = touch.location(in: self.view)
                (view as! ChorusView).addCircle(point: location)
                //Scale the range (0 ~ 1)
                location.x = location.x/self.view.frame.size.width
                location.y = location.y/self.view.frame.size.height
                //Store touch positions in a dictionary
                fingers[touch] = location
                //Update synth
                synth.update(id: touch.hash, point: location)
            }
        }
    }
    
    // MARK: - Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Check if touch exists
            if fingers[touch] != nil {
                //Update location
                var location = touch.location(in: self.view)
                (view as! ChorusView).addCircle(point: location)
                //Draw a circle to the touch location
                //Scale the range
                location.x = location.x/self.view.frame.size.width
                location.y = location.y/self.view.frame.size.height
                //Store touch positions in a dictionary using their hash
                fingers[touch] = location
                synth.update(id: touch.hash, point: location)
            }
        }
    }
    
    // MARK: - Touch Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Check if touch exists
            if fingers[touch] != nil {
                //Remove touch from the dictionary
                fingers.removeValue(forKey: touch)
                synth.stopSynth(id: touch.hash)
            }
        }
        
        // Remove all circles
        if fingers.count <= 0 {
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Touch Canclled
    // Called when iOS cancels a touch after receiving an interruption
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Check if touch exists
            if fingers[touch] != nil {
                //Remove touch from the dictionary
                fingers.removeValue(forKey: touch)
                synth.stopSynth(id: touch.hash)
            }
        }
        
        // Remove all circles
        if fingers.count <= 0 {
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}

// MARK: - UIViewController Container
struct ChorusControllerContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = ChorusController
    
    func makeUIViewController(context: Context) -> ChorusController {
        let controller = ChorusController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ChorusController, context: Context) {}
}
