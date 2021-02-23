//
//  SynthController.swift
//  Synthesizer
//
//  Created by Akito van Troyer on 1/27/21.
//

import Foundation
import SwiftUI
import AudioKit
import Sliders

class SynthController: ObservableObject, KeyboardDelegate {
    let engine = AudioEngine()
    var osc = MorphingOscillator(waveformArray: [Table(.sine), Table(.sawtooth), Table(.square), Table(.triangle)], amplitude: 0)
    
    var amplitudeRange: ClosedRange<AUValue> = 0.1...1
    @Published var amplitude: AUValue = 0.2
    
    var amplitudeRamp: ClosedRange<AUValue> =
        0.1...1
    @Published var ramp: AUValue = 0.2
    
    init() {
        engine.output = osc
    }
    
    func start(){
        osc.index = 0
        osc.start()
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
    }
    
    func stop(){
        osc.stop()
        engine.stop()
    }
    
    func setWaveform(tableType: TableType) {
        switch tableType {
        case .sine:
            osc.index = 0
        case .sawtooth:
            osc.index = 1
        case .square:
            osc.index = 2
        case .triangle:
            osc.index = 3
        default:
            osc.index = 0
        }
    }
    
    func noteOn(note: MIDINoteNumber) {
        osc.frequency = note.midiNoteToFrequency()
        osc.amplitude = amplitude
        osc.$amplitude.ramp(to: amplitude, duration: ramp)
    }
    
    func noteOff(note: MIDINoteNumber) {
        osc.amplitude = 0
    }
}

struct SynthView : View {
    @ObservedObject var controller = SynthController()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            Spacer()
            ButtonView(controller: controller)
            Spacer()
            SliderView(controller: controller)
            Spacer()
            KeyboardWidget(firstOctave: 2, octaveCount: 3, delegate: controller)
                .frame(height: screenSize.height/2)

        }
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
    }
}

// A view responsible for creating buttons for changing waveforms
// Buttons are stacked horizontally
struct ButtonView: View {
    var controller:SynthController
    @State var tableType:TableType = .sine
    
    var body: some View {
        HStack {
            Button(action: {
                self.tableType = .sine
                controller.setWaveform(tableType: .sine)
            }) {
                Image(tableType == .sine ? "SIN" : "SINOFF")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Button(action: {
                self.tableType = .sawtooth
                controller.setWaveform(tableType: .sawtooth)
            }) {
                Image(tableType == .sawtooth ? "SAW" : "SAWOFF")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Button(action: {
                self.tableType = .square
                controller.setWaveform(tableType: .square)
            }) {
                Image(tableType == .square ? "SQR" : "SQROFF")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Button(action: {
                self.tableType = .triangle
                controller.setWaveform(tableType: .triangle)
            }) {
                Image(tableType == .triangle ? "TRI" : "TRIOFF")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
        
    }
}

struct SliderView: View {
    @ObservedObject var controller = SynthController()
    
    var body: some View {
        HStack{
            Text("Amplitude")
            Text("\(controller.amplitude, specifier: "%0.2f") dB")
        }
        ValueSlider(value: $controller.amplitude, in: controller.amplitudeRange).valueSliderStyle(HorizontalValueSliderStyle(thumbSize: CGSize(width: 15, height: 15), thumbInteractiveSize: CGSize(width: 25, height: 25)))
            .padding()
            .frame(height: 10)
        
        HStack{
            Text("Ramp")
            Text("\(controller.ramp, specifier: "%0.2f") s")
        }
        
        ValueSlider(value: $controller.ramp, in: controller.amplitudeRamp).valueSliderStyle(HorizontalValueSliderStyle(thumbSize: CGSize(width: 15, height: 15), thumbInteractiveSize: CGSize(width:25, height: 25)))
            .padding()
            .frame(height: 20)
            
        .onAppear {
            self.controller.start()
        }.onDisappear {
            self.controller.stop()
        }
    }

}


// This struct is needed to make KeyboardView from AudioKit available for SwiftUI
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
        return view
    }

    func updateUIView(_ uiView: KeyboardView, context: Context) {
        //
    }
}

struct SynthView_Previews: PreviewProvider {
    static var previews: some View {
        SynthView()
    }
    
}
