//
//  GameScene.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Nodes
    var ownPlayer: Player!
    var opponentPlayer: Player!
    
    //Player Names
    var playerAName = "A"
    var playerBName = "B"
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
        ownPlayer = createPlayerAt(CGPointMake(200, 200))
        opponentPlayer = createPlayerAt(CGPointMake(200, 400))
        self.addChild(ownPlayer)
        self.addChild(opponentPlayer)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            ownPlayer.shootBullet()
            }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //MARK- Spawn functions
    func createPlayerAt(location: CGPoint) -> Player{
        let sprite = Player(imageNamed:"Spaceship")
        sprite.name = "Player"
        sprite.xScale = 0.2
        sprite.yScale = 0.2
        sprite.position = location
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        sprite.physicsBody!.affectedByGravity = false
        sprite.physicsBody!.usesPreciseCollisionDetection = true
        sprite.physicsBody!.contactTestBitMask = 2
        return sprite;
    }
    
    //MARK- Movement functions
    func moveOwnPlayer(direction: PlayerMovement) {
        ownPlayer.move(direction)
    }
    
    func rotateOwnPlayer(clockwise: Bool) {
        ownPlayer.rotate(clockwise)
    }
    
    //MARK:- Explosion
    
    //MARK:- Collisions
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyA
        if(firstBody.node?.name != secondBody.node?.name) {
            if(firstBody.node?.name == "Bullet") {
                firstBody.node?.removeFromParent()
            }
            else {
                secondBody.node?.removeFromParent()
            }
        }
    }
}
