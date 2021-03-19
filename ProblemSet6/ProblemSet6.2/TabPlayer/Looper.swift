//
//  Looper.swift
//  TabPlayer
//
//  Created by Noah Leong on 3/16/21.
//


import SwiftUI
import AVFoundation
import AudioKit
import Sliders

class Looper: ObservableObject {
    @Published var looperStates = [Bool]()
    var players = [AppleSampler]()
    
    var amplitudeRange: ClosedRange<AUValue> = 0.1...1
    @Published var amplitude: AUValue = 0.2
    
    
    init() {
        let files = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: "Loops")
        
        do {
            for file in files {
                let audioFile = try AVAudioFile(forReading: URL(string: file)!)
                let player = AppleSampler()
                try player.loadAudioFile(audioFile)
                looperStates.append(false)
                players.append(player)
            }
        }
        catch let error {
            print("Cannot read audio file: ", error)
        }
    }
    
    func play(id: Int){
        try? players[id].play()
        //players[id].amplitude
    }
    
    func stop(id: Int){
        try? players[id].stop()
    }
}

struct LooperView: View {
    @ObservedObject var looper:Looper
    var rows = 1
    var columns = 2
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        Rectangle()
                            .fill(Color(looper.looperStates[row * columns + column] ? .gray : .red))
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged({_ in
                                        if !looper.looperStates[row * columns + column] {
                                            looper.looperStates[row * columns + column] = true
                                            looper.play(id: row * columns + column)
                                        }
                                    })
                                    .onEnded({_ in
                                        looper.looperStates[row * columns + column] = false
                                    })
                            )
                    }
                    Rectangle()
                        .fill(Color(looper.looperStates[0] ? .blue : .yellow))
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({_ in
                                    if !looper.looperStates[0] {
                                        looper.looperStates[0] = true
                                        looper.stop(id: 0)
                                    }
                                })
                                .onEnded({_ in
                                    looper.looperStates[0] = false
                                })
                        )
                    Rectangle()
                        .fill(Color(looper.looperStates[1] ? .blue : .yellow))
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({_ in
                                    if !looper.looperStates[1] {
                                        looper.looperStates[1] = true
                                        looper.stop(id: 1)
                                    }
                                })
                                .onEnded({_ in
                                    looper.looperStates[1] = false
                                })
                        )
                }
            }
            Rectangle()
                .fill(Color(looper.looperStates[0] ? .yellow: .blue))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({_ in
                            if !looper.looperStates[0] {
                                looper.looperStates[0] = true
                                looper.stop(id: 0)
                                looper.stop(id: 1)
                            }
                        })
                        .onEnded({_ in
                            looper.looperStates[0] = false
                        }))
        }
    }
}

/*struct SliderView: View {
    @ObservedObject var looper = Looper()
    
    var body: some View {
        HStack{
            Text("Amplitude")
        }
        ValueSlider(value: $looper.amplitude, in: looper.amplitudeRange)
            .valueSliderStyle
        (HorizontalValueSliderStyle(thumbSize: CGSize(width: 15, height: 15), thumbInteractiveSize: CGSize(width: 25, height: 25)))
            .onAppear {
                self.looper.start()
            }.onDisappear {
                self.looper.stop()
            }
    }
}
*/
struct LooperViewView_Previews: PreviewProvider {
    static var previews: some View {
        LooperView(looper: Looper())
    }
}
