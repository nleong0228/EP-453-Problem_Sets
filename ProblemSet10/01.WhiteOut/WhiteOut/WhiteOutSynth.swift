//
//  WhiteOutSynth.swift
//  WhiteOut
//
//  Created by Akito van Troyer on 4/2/21.
//

import AudioKit
import Foundation

class WhiteOutSynth {
    var engine = AudioEngine()
    var noise:WhiteNoise!
    var filter:LowPassFilter!
    var reson1, reson2, reson3, reson4, reson5, reson6, reson7, reson8, reson9, reson10:ResonantFilter!
    var reverb:Reverb!
    var fft:FFTTap!
    var mic:AudioEngine.InputNode!
    var amp:AmplitudeTap!
    var fftData = [Float]()
    var mixer:Mixer!
    
    init(){
        // Track the amp of microhpne input
        guard let input = engine.input else {
            fatalError()
        }
        
        //Track microphone signal
        mic = input
        amp = AmplitudeTap(mic)
    
        // Keep the audio silent at the beginning
        
        noise = WhiteNoise(amplitude: 0)
        

        reson1 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/10)), bandwidth: 600))
        reson2 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/9)), bandwidth: 600))
        reson3 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/8)), bandwidth: 600))
        reson4 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/7)), bandwidth: 600))
        reson5 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/6)), bandwidth: 600))
        reson6 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/5)), bandwidth: 600))
        reson7 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/4)), bandwidth: 600))
        reson8 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/3)), bandwidth: 600))
        reson9 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/2)), bandwidth: 600))
        reson10 = (ResonantFilter(noise, frequency: AUValue(Settings.sampleRate * (0.5/1)), bandwidth: 600))
        
        let fader1 = reson1!
        let fader2 = reson2!
        let fader3 = reson3!
        let fader4 = reson4!
        let fader5 = reson5!
        let fader6 = reson6!
        let fader7 = reson7!
        let fader8 = reson8!
        let fader9 = reson9!
        let fader10 = reson10!
        
        filter = LowPassFilter(noise, cutoffFrequency: AUValue(Settings.sampleRate * 0.125), resonance: 0)
        reverb = Reverb(filter)
        
        //Add Fader to the mic input, a trick to get FFTTap to get audio signal from the mic input
        let fader0 = Fader(mic)
        
        let faders = [fader0, fader1, fader2, fader3, fader4, fader5, fader6, fader7, fader8, fader9, fader10]
        
        for fader in faders {
            mixer = Mixer(Fader(faders[0], gain: 0), reverb)
        }
        
        // Track the spectrum of the filtered noise
        fft = FFTTap(fader0){ fftData in
            self.fftData = fftData
        }

        // Make AudioKit more responsive to microphone input
        Settings.bufferLength = .shortest
    }
    
    func start(){
        //Start microphon input and noise source
        mic.start()
        noise.start()
        
        //Start the audio engine
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            print(error)
        }

        //Taps seemed to like to start after the engine is started
        fft.start()
        amp.start()
        
        // Start a timer to track microphone amplitude
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAmp), userInfo: nil, repeats: true)
    }
    
    func stop(){
        mic.stop()
        fft.start()
        amp.stop()
        engine.stop()
    }
    
    @objc func updateAmp(){
        noise.amplitude = amp.amplitude * 15
    }
    
    //Assumes freq value in between 0 ~ 1
    func setFrequency(freq: Double) {
        filter?.cutoffFrequency = AUValue(freq * Settings.sampleRate * 0.125)
    }
    
    //Assumes res value in between 0 ~ 1
    func setResonance(res: Double) {
        filter?.resonance = AUValue(res * 20)
    }
    
    func getFFTData() -> [Float] {
        return fft.fftData
    }
}
