//
//  ContentView.swift
//  MultiTouchSynth
//
//  Created by Akito van Troyer on 3/15/21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(
                    destination: MultiTouchControllerContainer()){
                    Text("Go to MultiTouch >")
                        .padding()
                }
                Spacer()
                NavigationLink(destination: XYPadControllerContainer()){
                    Text("Go to XYPad > ")
                        .padding()
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
