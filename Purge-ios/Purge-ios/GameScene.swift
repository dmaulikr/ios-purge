//
//  GameScene.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

let playerCategory: UInt32 = 0x1 << 0
let bulletCategory: UInt32 = 0x1 << 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Nodes
    var ownPlayer: Player!
    var opponentPlayer: Player!
    private var explosionTextures: [AnyObject]!
    
    //Player Names
    var playerAName = "A"
    var playerBName = "B"
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        loadExplosion()
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
        sprite.physicsBody?.categoryBitMask = playerCategory
        sprite.physicsBody?.collisionBitMask = playerCategory | bulletCategory
        sprite.physicsBody?.contactTestBitMask =
            playerCategory | bulletCategory
        return sprite
    }
    
    //MARK- Movement functions
    func moveOwnPlayer(direction: PlayerMovement) {
        ownPlayer.move(direction)
    }
    
    func rotateOwnPlayer(clockwise: Bool) {
        ownPlayer.rotate(clockwise)
    }
    
    //MARK:- Explosion
    
    func loadExplosion() {
        let explosionAtlas = SKTextureAtlas(named: "EXPLOSION")
        var textureNames = explosionAtlas.textureNames
        self.explosionTextures = []
        for name in textureNames {
            let texture = explosionAtlas.textureNamed(name as! String)
            explosionTextures.append(texture)
        }

    }
    
    func playExplosion(location: CGPoint) {
        let explosion = SKSpriteNode(texture: explosionTextures![0] as! SKTexture)
        explosion.zPosition = 1
        explosion.xScale = 0.6;
        explosion.yScale = 0.6;

        explosion.position = location
        addChild(explosion)
        let explosionAction = SKAction.animateWithTextures(explosionTextures, timePerFrame: 0.03)
        let remove = SKAction.removeFromParent()
        explosion.runAction(SKAction.sequence([explosionAction,remove]))
    }
    
    //MARK:- Collisions
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if(firstBody.node?.name != secondBody.node?.name) {
            if(firstBody.node?.name == "Bullet") {
                firstBody.node?.removeFromParent()
            }
            else {
                secondBody.node?.removeFromParent()
            }
            playExplosion(contact.contactPoint)
        }
    }
}
