//
//  ContentView.swift
//  MIDIOutTest
//
//  Created by Akito van Troyer on 4/20/21.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var screenSize = UIScreen.main.bounds
    let sequenceScene = SequenceScene()
    
    var scene: SKScene {
        sequenceScene.size = CGSize(width: screenSize.width, height: screenSize.height)
        sequenceScene.scaleMode = .fill
        
        sequenceScene.view?.ignoresSiblingOrder = true
        sequenceScene.view?.showsFPS = true
        
        sequenceScene.view?.showsNodeCount = true
        
        return sequenceScene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: screenSize.width, height: screenSize.height)
            .ignoresSafeArea()
            .onAppear(){
                
            }
            .onDisappear(){
                
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
