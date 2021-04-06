//
//  LibraryView.swift
//  AudioRecorder
//
//  Created by Akito van Troyer on 3/26/21.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var controller = LibraryController()
    @ObservedObject var recordcontroller = RecorderController()
    var recorder = AudioRecorder()
    
    var body: some View {
        Button(action: {
            recorder.deleteRecordings()
        }) {
            Image(systemName: "trash.fill")
        }
        //List all recorded sound files
        List {
            ForEach(0..<controller.recordings.count, id: \.self) { index in
                Button(action: {controller.play(index: index)}){
                    Text(controller.recordings[index])
                }
            }
        }
        
        .onAppear(){
            if(controller.recordings.count != 0)
            {
                controller.load()
            }
            if(recordcontroller.isRecording == true)
            {
                recordcontroller.stop()
            }
            controller.start()
            print(controller.recordings.count)
        }
        .onDisappear(){
            controller.stop()
        }
    }
}
