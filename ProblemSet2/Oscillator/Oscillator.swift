//
//  Oscillator.swift
//  Oscillator
//
//  Created by Akito van Troyer on 1/19/21.
//

import Foundation
import AudioKit
import SwiftUI
import Sliders
import AVFoundation

class OscillatorController: ObservableObject {
    let engine = AudioEngine()
    let osc = Oscillator(waveform: Table(.sawtooth))
    
    var freqencyRange: ClosedRange<AUValue> = 220...880
    @Published var frequency: AUValue = 440 {
        didSet {
            osc.$frequency.ramp(to: frequency, duration: 0.2)
        }
    }
    
    var amplitudeRange: ClosedRange<AUValue> = 0...1
    @Published var amplitude: AUValue = 0.2 {
        didSet {
            osc.$amplitude.ramp(to: amplitude, duration: 0.2)
        }
    }
    
    init() {
        engine.output = osc
        osc.start()
    }
    
    func start(){
        osc.frequency = 440
        osc.amplitude = 0.2
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
}

struct OscillatorView: View {
    @ObservedObject var controller = OscillatorController()
    
    var body: some View {
        VStack{
            HStack{
                Text("Frequency")
                Spacer()
                Text("\(controller.frequency, specifier: "%0.2f") Hz")
            }
            .padding()
            ValueSlider(value: $controller.frequency, in: controller.freqencyRange)
                .valueSliderStyle(HorizontalValueSliderStyle(
                    thumbSize: CGSize(width: 20, height: 20),
                    thumbInteractiveSize: CGSize(width: 44, height: 44)))
                .padding()
                .frame(height: 50)
        
            HStack{
                Text("Amplitude")
                Spacer()
                Text("\(controller.amplitude, specifier: "%0.2f") dB")
            }
            .padding()
            ValueSlider(value: $controller.amplitude, in: controller.amplitudeRange).valueSliderStyle(HorizontalValueSliderStyle(thumbSize: CGSize(width: 20, height: 20), thumbInteractiveSize: CGSize(width: 44, height: 44)))
                .padding()
                .frame(height: 50)
        }
        .frame(height: 100)
        .onAppear {
            self.controller.start()
        }.onDisappear {
            self.controller.stop()
        }
    }
}

struct OscillatorView_Previews: PreviewProvider {
    static var previews: some View {
        OscillatorView()
            .previewLayout(PreviewLayout.fixed(width: 400, height: 200))
    }
}
