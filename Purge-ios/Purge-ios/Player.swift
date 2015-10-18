//
//  Player.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

enum PlayerMovement: Int {
    case Right = 0, Down, Left, Up
}

class Player: SKSpriteNode {
    var health = 100
    var playerName = "1"
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
    
    func shootBullet(playerId: String) {
        let bullet = Bullet(imageNamed: "laser")
        bullet.zRotation = zRotation
        bullet.position = position//CGPointMake(position.x - size.width * sin(zRotation) + 10 , position.x + size.height * cos(zRotation) + 10)
        bullet.name = "Bullet"
        bullet.playerName = playerId
        bullet.size = CGSizeMake(20, 40)
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.usesPreciseCollisionDetection = true
//        bullet.physicsBody?.dynamic = false
        bullet.physicsBody?.categoryBitMask = playerCategory
        bullet.physicsBody?.collisionBitMask = playerCategory | bulletCategory
        bullet.physicsBody?.contactTestBitMask =
            playerCategory | bulletCategory
        self.parent?.addChild(bullet)
        bullet.fire()
        
    }
}
