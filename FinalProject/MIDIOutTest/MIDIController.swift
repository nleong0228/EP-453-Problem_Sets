//
//  MIDIController.swift
//  MIDIOutTest
//
//  Created by Akito van Troyer on 4/20/21.
//

import SwiftUI
import AudioKitUI
import AudioKit

class MIDIController: ObservableObject, KeyboardDelegate {
    let midi = MIDI()
    
    init(){
        midi.openOutput()
        print(midi.outputPort, midi.destinationNames)
    }
    
    func noteOn(note: MIDINoteNumber) {
        midi.sendEvent(MIDIEvent(noteOn: note, velocity: 127, channel: 1))
    }
    
    func noteOff(note: MIDINoteNumber) {
        midi.sendEvent(MIDIEvent(noteOff: note, velocity: 0, channel: 1))
    }
}


struct MIDIView : View {
    @ObservedObject var controller = MIDIController()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            KeyboardWidget(firstOctave: 2, octaveCount: 2, delegate: controller)
                .frame(height: screenSize.height/2)
        }
    }
}

// This struct is needed to make KeyboardView from AudioKitUI available for SwiftUI
struct KeyboardWidget: UIViewRepresentable {

    typealias UIViewType = KeyboardView
    
    var firstOctave = 2
    var octaveCount = 2
    var delegate: KeyboardDelegate?

    func makeUIView(context: Context) -> KeyboardView {
        let view = KeyboardView()
        view.delegate = delegate
        view.firstOctave = firstOctave
        view.octaveCount = octaveCount
        view.polyphonicMode = true
        return view
    }

    func updateUIView(_ uiView: KeyboardView, context: Context) {
        //
    }
}
