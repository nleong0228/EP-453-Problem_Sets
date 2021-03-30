//
//  MultiTouchSynth2.swift
//  MultiTouchSynth
//
//  Created by Noah Leong on 3/29/21.
//

import AudioKit
import AVFoundation

class MultiTouchSynth2 {
    let engine = AudioEngine()
    let mixer = Mixer()
    var ids = [Int:Int]()
    var nodes = [[Node]]()
    var count = 0
    
    init(){
        for _ in 0..<XYPadController.numFingers {
            add()
        }
    }

    func add(){
        let osc = Oscillator()
        let filter = LowPassFilter(osc)
        let env = AmplitudeEnvelope(filter)
        env.attackDuration = 0.1
        env.decayDuration = 0.1
        env.releaseDuration = 0.1
        let reverb = Reverb(env)
        
        mixer.addInput(reverb)
        
        //Keep track of all our Nodes so that we can modify them later
        nodes.append([osc, filter, reverb, env])
    }
    
    func update(id: Int, point: CGPoint){
        //Check if the hash id from a touch point exsits in the ids dictionary
        if ids[id] == nil {
            //if the id does not exist, make a link between the hash id and count id in this synth class
            ids[id] = count
            //Advance the count
            count += 1
            //Start the synthesizer for this particular touch
            let synths = nodes[ids[id]!]
            let env = synths[3] as! AmplitudeEnvelope
            env.start()
        }
        //Convert point.y (0~1) to frequency range (60 ~ 3000)
        let freq = scale(num: point.y, minNum: 0, maxNum: 1, scaleMin: 3000, scaleMax: 60)
        let dryWet = scale(num: point.y, minNum: 0, maxNum: 1, scaleMin: 0, scaleMax: 0.75)
        let synths = nodes[ids[id]!]
        let osc = synths[0] as! Oscillator
        osc.frequency = AUValue(freq)
        //Morph between four wavetables (0 ~ 3)
        let filter = synths[1] as! LowPassFilter
        let reverb = synths[2] as! Reverb
        filter.cutoffFrequency = AUValue(freq)
        reverb.dryWetMix = AUValue(dryWet)
    }
    
    func stopSynth(id: Int){
        let synths = nodes[ids[id]!]
        (synths[3] as! AmplitudeEnvelope).stop()
        ids.removeValue(forKey: id)
        count -= 1
    }
    
    func start(){
        engine.output = mixer
        
        do {
            try engine.start()
        } catch let error {
            Log(error)
        }
        
        
        //Start all Oscillator
        for node in nodes {
            (node[0] as! Oscillator).start()
        }
    }
    
    func stop() {
        //Stopt all Oscillator
        for node in nodes {
            (node[0] as! MorphingOscillator).stop()
        }
        engine.stop()
    }
    
    func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat,
    scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
}
