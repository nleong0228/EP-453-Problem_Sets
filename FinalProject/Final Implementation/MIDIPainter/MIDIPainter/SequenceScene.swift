//
//  SequenceScene.swift
//
//  Created by Noah Leong on 4/22/21.
//

import UIKit
import SpriteKit
import AudioKit

class SequenceScene: SKScene, ObservableObject {
    
    var circleArray = [SKShapeNode]()
    var lineArray = [SKShapeNode]()
    var pathArray = [CGPoint]()
    let circleRadius:CGFloat = 15
    var pause:Bool = false
    var count = 0
    var arrcount = 0
    var curCC = 0
    var CC = 14
    let controller = MIDIController()
    var timer: Timer?
    let screenSize = UIScreen.main.bounds
    var previous:CGPoint?

    func touchDown(atPoint pos : CGPoint){
        pathArray.removeAll()
        let screenSum = Float(screenSize.width + screenSize.height)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [self]timer in
            
            arrcount = circleArray.count
            
            if curCC >= arrcount
            {
                curCC = 0
            }
            
            let val = getPos(index: curCC)
            let scaledValue = scale(num: Float(val), minNum: 0, maxNum: screenSum, scaleMin: 0, scaleMax: 127)
            
            controller.controlChange(cc: MIDIByte((curCC + CC)), value: MIDIByte(scaledValue))
            
            curCC += 1
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        pathArray.append(pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        pathArray.append(pos)
        
        print(checkPos(pos: pos))
        if checkPos(pos: pos) == true
        {
            createLine()
            followLine()
        }
        else
        {
            remove(pos: pos)
        }

        previous = pos
    }
    

    func checkPos(pos: CGPoint) -> Bool {
        var isTouching:Bool = false
        for path in pathArray
        {
            if path != pos
            {
                isTouching = true
            }
        }
        
        return isTouching
    }
    
    func getPos(index: Int) -> (Int){
        var sumPos = 0
        for _ in circleArray {
            let pos = circleArray[index]
            
            sumPos = Int(pos.position.x + pos.position.y)
        }
        
        return sumPos
    }
    
    
    func createLine() -> (CGPath) {
        
        let path = CGMutablePath()
        path.move(to: pathArray[0])
        
        for point in pathArray{
            path.addLine(to: point)
        }
        
        let line = SKShapeNode()
        line.name = "line" + String(count)
        
        line.path = path
        line.fillColor = .clear
        line.lineWidth = 5
        line.strokeColor = SKColor.init(red: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 1)
        line.lineCap = .round
        line.glowWidth = 10
        
        self.addChild(line)
        
        lineArray.append(line)
        
        return line.path!
    }
    
    func followLine() {
        let move = SKAction.follow(createLine(), asOffset: false, orientToPath: false, speed: 200)
        let reversedMove = move.reversed()
        let sequence = SKAction.sequence([move, reversedMove])
        let endlessAction = SKAction.repeatForever(sequence)
        let circle = createCircle()
        
        circle.run(endlessAction)
    }
    
    func createCircle() -> (SKShapeNode) {
        let circle = SKShapeNode(circleOfRadius: circleRadius)
        circle.name = "circle" + String(count)
        count += 1
        circle.strokeColor = .white
        circle.glowWidth = 4.0
        circle.fillColor = SKColor.init(red: 0, green: 0, blue: 1, alpha: 1)
        
        self.addChild(circle)
        
        circleArray.append(circle)
        
        return circle
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    func scale(num: Float, minNum: Float, maxNum: Float, scaleMin: Float, scaleMax: Float) -> Float {
        if (num <= minNum) {return scaleMin}
        if (num >= maxNum) {return scaleMax}
        
        return (num-minNum)/(maxNum-minNum) * (scaleMax-scaleMin) + scaleMin
    }
    
    func remove(pos: CGPoint) {
        let hit = nodes(at: pos)
        
        for h in hit
        {
            h.removeFromParent()
            circleArray[curCC - 1].removeFromParent()
        }
        
        circleArray.remove(at: curCC - 1)
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchDown(atPoint: t.location(in:self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchMoved(toPoint: t.location(in: self))}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchUp(atPoint: t.location(in: self))}
    }
}
