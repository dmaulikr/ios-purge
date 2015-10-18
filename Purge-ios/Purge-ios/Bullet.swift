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
    let bulletMovementDistance: CGFloat = 10

    func fire() {
        runAction(SKAction.repeatActionForever(SKAction.moveBy(CGVectorMake(cos(zRotation), sin(zRotation)), duration: bulletMovementUnitTime)))
    }
}
