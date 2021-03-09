//
//  XYEffect.swift
//  Navigation
//
//  Created by Noah Leong on 3/8/21.
//

import SwiftUI
import AudioKit

struct EffectView: View {
    @ObservedObject var controller:ProcessorController
    let screenSize = UIScreen.main.bounds
    @State private var currentPosition: CGSize = .zero
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
        }
        .frame(width: screenSize.width, height: screenSize.height)
        .background(Color.white)
        .gesture(
            DragGesture(minimumDistance: 0).onChanged{ value in
                let x = value.location.x
                let y = value.location.y
                
                self.currentPosition = CGSize(width: x - screenSize.width * 0.5, height: value.location.y - screenSize.height * 0.5)
                controller.chorus?.frequency = AUValue(x / screenSize.width)
                controller.chorus?.depth = AUValue(y / screenSize.height)
            })
        .navigationBarTitle("XYPad (chorus)")
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(controller: ProcessorController())
    }
}
