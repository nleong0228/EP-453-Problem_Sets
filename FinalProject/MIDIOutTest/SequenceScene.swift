//
//  SequenceScene.swift
//  MIDIOutTest
//
//  Created by Noah Leong on 4/22/21.
//

import UIKit
import SpriteKit

class SequenceScene: SKScene {
    var movingFollow: Follow?
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    let circleRadius: CGFloat = 15
    var count = 1
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "follow" {
                let follow = node as! Follow
                follow.addMovingPoint(point: location)
                movingFollow = follow
            }
            else {
                createFollow(location: CGPoint(x: location.x, y: location.y))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if let follow = movingFollow {
                follow.addMovingPoint(point: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingFollow = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        enumerateChildNodes(withName: "follow", using: {node, stop in
            let follow = node as! Follow
            follow.move(dt: self.dt)
        })
        
        drawLines()
    }
    
    func createFollow(location: CGPoint){
        let follow = SKShapeNode(circleOfRadius: circleRadius)
        follow.position = location
        follow.name = "follow" + String(count)

        follow.strokeColor = SKColor.white
        follow.glowWidth = 4.0
        follow.fillColor = SKColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
        
        self.addChild(follow)
    }
    
    func drawLines() {
        enumerateChildNodes(withName: "follow", using: {node, stop in
            let follow = node as! Follow
            if let path = follow.createPathToMove() {
                let shapeNode = SKShapeNode()
                shapeNode.path = path
                shapeNode.name = "line"
                shapeNode.strokeColor = UIColor.red
                shapeNode.fillColor = UIColor.blue
                shapeNode.lineWidth = 2
                shapeNode.zPosition = 1
                
                self.addChild(shapeNode)
            }
        })
    }
}
