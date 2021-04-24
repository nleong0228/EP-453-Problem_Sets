//
//  SequenceScene.swift
//
//  Created by Noah Leong on 4/22/21.
//

import UIKit
import SpriteKit

class SequenceScene: SKScene {
    
    var pathArray = [CGPoint]()
    let circleRadius:CGFloat = 15
    var pause:Bool = false
    var count = 1
    var CC = 14
    let controller = MIDIController()
    var nodePosition = CGPoint()
    
    func touchDown(atPoint pos : CGPoint){
        pathArray.removeAll()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        pathArray.append(pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        print(pathArray.count)
        
        createLine()
        
        followLine()
    }
    
    func createLine() -> (CGPath) {
        
        let path = CGMutablePath()
        path.move(to: pathArray[0])
        
        for point in pathArray{
            path.addLine(to: point)
        }
        
        let line = SKShapeNode()
        line.name = "line" + String(count)
        count += 1
        
        line.path = path
        line.fillColor = .clear
        line.lineWidth = 5
        line.strokeColor = SKColor.init(red: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 1)
        line.lineCap = .round
        line.glowWidth = 10
        
        self.addChild(line)
        
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
        circle.strokeColor = .white
        circle.glowWidth = 4.0
        circle.fillColor = SKColor.init(red: 0, green: 0, blue: 1, alpha: 1)
        
        self.addChild(circle)
        
        return circle
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    override func update(_ currentTime: TimeInterval) {
      /*  var pos: CGPoint
        let circle = createCircle()
        let name = circle.name
        
        pos = circle.position
        
        if name != nil && (name?.contains("circle"))! {
            if count > 1
            {
                CC += 1
            }
        }
        */
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
