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
            action = SKAction.moveByX(CGFloat(0), y: playerMovementDistance, duration: playerMovementUnitTime)
            runAction(action)
        
        case .Down:
            action = SKAction.moveByX(CGFloat(0), y: -playerMovementDistance, duration: playerMovementUnitTime)
            runAction(action)
            
        case .Left:
            action = SKAction.moveByX(-playerMovementDistance, y:CGFloat(0) , duration: playerMovementUnitTime)
            runAction(action)
            
        case .Right:
            action = SKAction.moveByX(playerMovementDistance, y:CGFloat(0) , duration: playerMovementUnitTime)
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
}
