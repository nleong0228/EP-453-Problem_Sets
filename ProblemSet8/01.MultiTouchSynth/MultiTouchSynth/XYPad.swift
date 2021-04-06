//
//  XYPad.swift
//  MultiTouchSynth
//
//  Created by Noah Leong on 3/29/21.
//
//
//  XYPad.swift
//  Navigation
//
//  Created by Akito van Troyer on 1/31/21.
//

import SwiftUI
import AudioKit

class XYPad: ObservableObject {
    @Published var fingers = [UITouch:CGPoint]()
    let synth = MultiTouchSynth2()
    
    func start(){
        synth.start()
    }
    
    func stop(){
        synth.stop()
    }
    
    // MARK: - Touch Began
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if fingers[touch] == nil {
                var location = touch.location(in: self.view)
                (view as! XYPad).addCircle(point: location)
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
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Check if touch exists
            if fingers[touch] != nil {
                for subview in self.view.subviews {
                    subview.removeFromSuperview()
                }
                //Update location
                var location = touch.location(in: self.view)
                (view as! XYPad).addCircle(point: location)
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
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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

struct XYPadView: View {
    @ObservedObject var controller:XYPad
    let screenSize = UIScreen.main.bounds
    @State private var currentPosition: CGSize = .zero
    var touches = 10
    var body: some View {
        ForEach(0..<touches, id: \.self) { touch in
            VStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                    .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                }
            .frame(width: screenSize.width, height: screenSize.height)
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0).onChanged{ value in
                    let x = value.location.x
                    let y = value.location.y
                
                    self.currentPosition = CGSize(width: x - screenSize.width * 0.5, height: value.location.y - screenSize.height * 0.5)
                    synth.filter.cutoffFrequency = AUValue(x / screenSize.width) * Float(Settings.sampleRate * 0.125)
                    controller.lpf?.resonance = AUValue(y / screenSize.height) * 20
                })
            .navigationBarTitle("XYPad")
        }
    }
}

struct XYPadView_Previews: PreviewProvider {
    static var previews: some View {
        XYPadView(controller: XYPad())
    }
}
