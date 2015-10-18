//
//  Player.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    var health = 100
    let movementUnitTime = 0.2
    
    func move(x: CGFloat, y: CGFloat){
        var moveAction = SKAction.moveTo(CGPointMake(x, y), duration: movementUnitTime)
        self.runAction(moveAction)
    }
}
