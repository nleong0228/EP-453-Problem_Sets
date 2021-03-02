//
//  PlaybackController.swift
//  SamplePlayback
//
//  Created by Akito van Troyer on 1/21/21.
//
import Foundation
import SwiftUI
import AudioKit
import AVFoundation
import Sliders

class PlaybackController: ObservableObject {
    let engine = AudioEngine()
    var mixer:Mixer?
    var guitar:AudioPlayer?
    var trumpet:AudioPlayer?
    var bass:AudioPlayer?
    var shaker:AudioPlayer?
    var loop:AudioPlayer?
    
    func setupPlayback(){
        let bassFile = loadAudioFile(file: "Sounds/Bass.wav")
        bass = AudioPlayer(file: bassFile!)
        bass?.isLooping = false
        let shakerFile = loadAudioFile(file: "Sounds/Shaker.wav")
        shaker = AudioPlayer(file: shakerFile!)
        shaker?.isLooping = false
        let guitarFile = loadAudioFile(file: "Sounds/guitar.wav")
        guitar = AudioPlayer(file: guitarFile!)
        guitar?.isLooping = false
        let trumpetFile = loadAudioFile(file: "Sounds/trumpet.wav")
        trumpet = AudioPlayer(file: trumpetFile!)
        trumpet?.isLooping = false
        
        let loopFile = loadAudioFile(file: "Sounds/loop.wav")
        loop = AudioPlayer(file: loopFile!)
        loop?.isLooping = true
        
        /*var variSpeed = VariSpeed(loop!)
        variSpeed.rate = 1.0*/
 
        mixer = Mixer([guitar!, trumpet!, loop!, shaker!, bass!])
        engine.output = mixer
        
        do {
            try engine.start()
        } catch {
            Log("AudioKit did not start! \(error)")
        }
    }
    
    func loadAudioFile(file: String) -> AVAudioFile? {
        var audioFile:AVAudioFile?
        guard let url = Bundle.main.resourceURL?.appendingPathComponent(file) else { return nil }
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: $file")
        }
        
        return audioFile
    }
    
    func stop(){
        engine.stop()
    }
    
    func playGuitar(){
        if ((guitar?.isStarted) != nil) {
            guitar?.stop()
        }
        guitar?.play()
    }
    
    func playTrumpet(){
        if((trumpet?.isStarted) != nil){
            trumpet?.stop()
        }
        trumpet?.play()
    }
    
    func playBass(){
        if((bass?.isStarted) != nil){
            bass?.stop()
        }
        bass?.play()
    }
    
    func playShaker(){
        if((shaker?.isStarted) != nil){
            shaker?.stop()
        }
        shaker?.play()
    }
    
    func playLoop(){
        loop?.play()
    }
    
    func stopLoop(){
        loop?.stop()
    }
}

struct PlaybackControlView: View {
    @ObservedObject var controller = PlaybackController()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("background")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack {
                        Button(action: controller.playShaker) {
                            Image("shaker")
                        }
                        .padding()
                        Button(action: controller.playBass) {
                            Image("bass")
                        }
                    }
                    HStack {
                        Button(action: controller.playGuitar) {
                            Image("guitar")
                        }
                        .padding()
                        Button(action: controller.playTrumpet) {
                            Image("trumpet")
                        }
                        .padding()
                    }
                    HStack {
                        Button(action: controller.playLoop) {
                            Text("Play")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 40))
                        }
                        .padding()
                        Spacer()
                        Button(action:controller.stopLoop) {
                            Text("Stop")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 40))
                        }
                        .padding()
                    }
                   /* HStack {
                        Text("Playback Speed")
                        ValueSlider(value: variSpeed.rate, in: controller.rateRange).valueSliderStyle(thumbSize: CGSize(width: 15, height: 15), thumbInteractiveSize: CGSize(width: 25, height: 25))).padding().frame(height: 10)*/
                    }
                }
            }
        }
        .onAppear {
            controller.setupPlayback()
        }
        .onDisappear {
            controller.stop()
        }
    }
}

struct PlaybackControlView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackControlView()
    }
}
