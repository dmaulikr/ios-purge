//
//  Player.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

enum PlayerMovement {
    case Left, Right, Up, Down
}

class Player: SKSpriteNode {
    var health = 100
    let playerMovementUnitTime = 0.2
    let playerMovementDistance: CGFloat = 10
    
    func move(direction: PlayerMovement){
        var action: SKAction!
        switch(direction) {
        case .Up:
            action = SKAction.moveByX(-playerMovementDistance * sin(zRotation), y: playerMovementDistance * cos(zRotation), duration: playerMovementUnitTime)
            runAction(action)
        
        case .Down:
            action = SKAction.moveByX(playerMovementDistance * sin(zRotation), y: -playerMovementDistance * cos(zRotation), duration: playerMovementUnitTime)
            runAction(action)
            
        case .Left:
            action = SKAction.moveByX(-playerMovementDistance * cos(zRotation), y: -playerMovementDistance * sin(zRotation), duration: playerMovementUnitTime)
            runAction(action)
            
        case .Right:
            action = SKAction.moveByX(playerMovementDistance * cos(zRotation), y: playerMovementDistance * sin(zRotation), duration: playerMovementUnitTime)
            runAction(action)
            
        default:
            break
        }
    }
    
    func rotate(clockwise: Bool) {
        let angle = clockwise ? -CGFloat(M_PI_4) : CGFloat(M_PI_4)
        let action = SKAction.rotateByAngle(angle, duration: playerMovementUnitTime)
        runAction(action)
    }
    
    func shootBullet() {
        let bullet = Bullet(imageNamed: "laser")
        bullet.zRotation = zRotation
        bullet.position = position
        bullet.name = "Bullet"
        bullet.size = CGSizeMake(20, 40)
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.usesPreciseCollisionDetection = true
        bullet.physicsBody!.contactTestBitMask = 1
        bullet.fire()
        self.parent?.addChild(bullet)
    }
}
