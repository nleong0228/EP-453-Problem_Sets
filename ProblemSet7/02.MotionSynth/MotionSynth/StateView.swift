//
//  StateView.swift
//  MotionSynth
//
//  Created by Noah Leong on 3/22/21.
//

import SwiftUI

struct StateView: View {
    @ObservedObject var controller = MotionController()
    
    var body: some View {
        ZStack {
            StateTrackView(position: controller.position, rotationAngle: controller.rotationAngle, acceleration: controller.acceleration, accelAvg: controller.accelAvg)
            VStack {
                StateSensorView(name: "Accel X:", value: controller.data.accelX)
                StateSensorView(name: "Accel Y:", value: controller.data.accelY)
                StateSensorView(name: "Accel Z:", value: controller.data.accelZ)
                StateSensorView(name: "Gyro X:", value: controller.data.gyroX)
                StateSensorView(name: "Gyro Y:", value: controller.data.gyroY)
                StateSensorView(name: "Gyro Z:", value: controller.data.gyroZ)
                StateSensorView(name: "Pitch:", value: controller.data.pitch)
                StateSensorView(name: "Roll:", value: controller.data.roll)
                StateSensorView(name: "Yaw:", value: controller.data.yaw)
                StateSensorView(name: "accelAvg:", value: Double(controller.accelAvg))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0).onChanged({ _ in
                controller.startSound()
            })
            .onEnded({ _ in
                controller.stopSound()
            })
        )
        .onAppear(){
            controller.start()
        }
        .onDisappear(){
            controller.stop()
        }
    }
}

struct StateSensorView: View {
    var name:String
    var value:Double
    
    var body: some View {
        HStack {
            Spacer()
            Text(name)
                .padding()
            Spacer()
            Text("\(value, specifier: "%.03f")")
                .padding()
                .frame(width: 100)
            Spacer()
        }
    }
}

struct StateTrackView: View {
    @ObservedObject var controller = MotionController()
    let screenSize = UIScreen.main.bounds
    var position: CGPoint
    var rotationAngle: CGFloat
    var acceleration: CGPoint
    var accelAvg: CGFloat
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(hue: Double(accelAvg), saturation: 1, brightness: 1, opacity: 1))
                .frame(width: scale(num: accelAvg, minNum: 0, maxNum: 1, scaleMin: 50, scaleMax: 150), height: scale(num: accelAvg, minNum: 0, maxNum: 1, scaleMin: 50, scaleMax: 150))
                .offset(x: self.acceleration.x, y: self.acceleration.y)
                .transformEffect(
                    CGAffineTransform(rotationAngle: rotationAngle)
                        .translatedBy(x: self.acceleration.x - 25, y: self.acceleration.x - 25)
                )
        }
        .frame(width: screenSize.width, height: screenSize.height)
    }
}

struct TapGestureView: View {
    @ObservedObject var controller = MotionController()
    @State var tapped = false
    
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded {_ in self.tapped = !self.tapped}
    }
    
    var body: some View {
        VStack{
            Rectangle()
                .fill(self.tapped ? Color.blue : Color.red)
                .frame(width: 50, height: 50)
                .gesture(tap)
        }
    }
}

func scale(num: CGFloat, minNum: CGFloat, maxNum: CGFloat, scaleMin: CGFloat, scaleMax: CGFloat) -> CGFloat {
    if (num <= minNum) {return scaleMin}
    if (num >= maxNum) {return scaleMax}
    return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        MotionView()
    }
    
}
