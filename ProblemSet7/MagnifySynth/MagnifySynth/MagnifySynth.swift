//
//  MagnifySynth.swift
//  MagnifySynth
//
//  Created by Noah Leong on 3/22/21.
//

import AVFoundation
import AudioKit

class MagnifySynth {
    let engine = AudioEngine()
    let fmOscillator = FMOscillator()
    let filter:MoogLadder?
    let reverb: CostelloReverb?
    
    init(){
        filter = MoogLadder(fmOscillator, cutoffFrequency: 5000, resonance: 0.3)
        reverb = CostelloReverb(filter!, feedback: 0.6, cutoffFrequency: 5000)
        
        engine.output = reverb
    }
    
    func start(){
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
    }
    
    func stop(){
        fmOscillator.stop()
        engine.stop()
    }
    
    func startSound() {
        fmOscillator.start()
    }
    
    func stopSound() {
        fmOscillator.stop()
    }
    
    func setFilter(magnifyBy: Double){
        let cutoff = 6000 * scale(num: CGFloat(magnifyBy), minNum: -1.5, maxNum: 1.5, scaleMin: 0, scaleMax: 1)
        let resonance = 0.333 * scale(num: CGFloat(magnifyBy), minNum: -1.5, maxNum: 1.5, scaleMin: 0, scaleMax: 1)
        
        filter!.cutoffFrequency = Float(1000 + cutoff)
        filter!.resonance = Float(0.6 + resonance)
    }
    
    func setModulationIndex(magnifyBy: Double){
        let modulationIndex = 100 * scale(num: CGFloat(magnifyBy), minNum: -CGFloat.pi, maxNum: CGFloat.pi, scaleMin: 0, scaleMax: 1)
        fmOscillator.modulationIndex = Float(20 + modulationIndex)
    }
    
    func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat, scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
}
