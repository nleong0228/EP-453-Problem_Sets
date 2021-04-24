//
//  MIDIController.swift
//  MIDIOutTest
//
//  Created by Akito van Troyer on 4/20/21.
//

import AudioKit

class MIDIController {
    let midi = MIDI()
    
    init(){
        midi.openOutput()
        print(midi.outputPort, midi.destinationNames)
    }
    
    func controlChange(cc: MIDIByte, value: MIDIByte) {
        midi.sendControllerMessage(cc, value: value)
    }
}



