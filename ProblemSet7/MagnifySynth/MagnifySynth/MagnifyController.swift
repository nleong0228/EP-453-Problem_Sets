//
//  MagnifyController.swift
//  MagnifySynth
//
//  Created by Noah Leong on 3/22/21.
//

import SwiftUI

class MagnifyController : ObservableObject {
    @Published var magnification:CGFloat = 0
    let magnifySynth = MagnifySynth()
    
    func start() {
        magnifySynth.start()
    }
    
    func stop() {
        magnifySynth.stop()
    }
    
    func startSound() {
        magnifySynth.startSound()
    }
    
    func stopSound() {
        magnifySynth.stopSound()
    }
    
    func setFilter(magnification: Double) {
        magnifySynth.setFilter(magnifyBy: 0.5)
    }
    
    func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat, scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
}


