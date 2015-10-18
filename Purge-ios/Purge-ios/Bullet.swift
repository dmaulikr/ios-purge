//
//  Bullet.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {
    let bulletMovementUnitTime = 0.2
    let bulletMovementDistance: CGFloat = 50

    var playerName = ""
    func fire() {
        runAction(SKAction.repeatActionForever( SKAction.moveByX(-bulletMovementDistance * sin(zRotation), y: bulletMovementDistance * cos(zRotation), duration: bulletMovementUnitTime)))
    }
}
