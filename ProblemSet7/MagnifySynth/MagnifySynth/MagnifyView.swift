//
//  MagnifyView.swift
//  MagnifySynth
//
//  Created by Noah Leong on 3/22/21.
//

import AudioKit
import SwiftUI

struct MagnifyView: View {
    @GestureState var magnifyBy = CGFloat(1.0)
    @ObservedObject var controller = MagnifyController()
    
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in gestureState = currentState
                
            }
    }
    
    var body: some View {
        SensorView(name: "Magnification: ", value: Double(magnifyBy))
        Circle()
            .frame(width: 100 * magnifyBy, height: 100 * magnifyBy, alignment: .center)
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
                controller.setFilter(magnification: Double(magnifyBy))
            }
            .onDisappear(){
                controller.stop()
            }
    }
}

struct SensorView: View {
    var name:String
    var value:Double
    
    var body: some View {
        HStack {
            Spacer()
            Text(name)
                .padding()
            Spacer()
            Text("\(value, specifier: "%.03f")")
                .padding()
                .frame(width: 100)
            Spacer()
        }
    }
}
