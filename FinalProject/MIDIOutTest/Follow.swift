//
//  FollowSprite.swift
//  MIDIOutTest
//
//  Created by Noah Leong on 4/22/21.
//

import SpriteKit

class Follow: SKSpriteNode {
    let POINTS_PER_SEC: CGFloat = 80.0
    
    var wayPoints: [CGPoint] = []
    var velocity = CGPoint(x: 0, y: 0)
    
    
    init(imageNamed name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    func addMovingPoint(point: CGPoint) {
        wayPoints.append(point)
    }
    
    func move(dt: TimeInterval) {
        let currentPosition = position
        var newPosition = position
        
        if wayPoints.count > 0 {
            let targetPoint = wayPoints[0]
            
            let offset = CGPoint(x: targetPoint.x - currentPosition.x, y: targetPoint.y - currentPosition.y)
            let length = Double(sqrtf(Float(offset.x * offset.x) + Float(offset.y * offset.y)))
            let direction = CGPoint(x:CGFloat(offset.x) / CGFloat(length), y: CGFloat(offset.y) / CGFloat(length))
            velocity = CGPoint(x: direction.x * POINTS_PER_SEC, y: direction.y * POINTS_PER_SEC)
            
            newPosition = CGPoint(x:currentPosition.x + velocity.x * CGFloat(dt), y:currentPosition.y + velocity.y * CGFloat(dt))
            position = newPosition
            
            if frame.contains(targetPoint) {
                wayPoints.remove(at: 0)
            }
        }
    }
    
    func createPathToMove() -> CGPath? {
        if wayPoints.count <= 1 {
            return nil
        }
        
        var ref = CGMutablePath()
        
        for wayPoint in 0..<wayPoints.count {
            let p = wayPoints[wayPoint]
            
            if wayPoint == 0 {
                ref.move(to: CGPoint(x: p.x, y: p.y))
            } else {
                ref.move(to: CGPoint(x: p.x, y: p.y))
            }
        }
        
        return ref
    }
}
