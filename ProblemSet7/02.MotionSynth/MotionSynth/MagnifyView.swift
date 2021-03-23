//
//  Magnify.swift
//  MotionSynth
//
//  Created by Noah Leong on 3/22/21.
//

import SwiftUI

struct MagnifyView: View {
    @ObservedObject var controller = MotionController()
    @GestureState var magnifyBy = CGFloat(1.0)

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }

    var body: some View {
        Circle()
            .frame(width: 100 * magnifyBy,
                   height: 100 * magnifyBy,
                   alignment: .center)
            .gesture(magnification)
        
            .gesture(
                DragGesture(minimumDistance: 0).onChanged({ _ in
                    controller.startSound()
                })
                .onEnded({ _ in
                    controller.stopSound()
                })
            )
            .onAppear(){
                controller.start()
            }
            .onDisappear(){
                controller.stop()
            }
    }
    
}

struct MagnifyView_Previews: PreviewProvider {
    static var previews: some View {
        MagnifyView()
    }
}
