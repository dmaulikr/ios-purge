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
enum Rotate: Int {
    case ClockWise = 0
    case AntiClockWise = 1
}

enum ValueType: String {
    case Rotate = "R"
    case Move = "M"
    case Shoot = "S"
    case Collide = "C"
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate, PNObjectEventListener {
    
    //Nodes
    var ownPlayer: Player!
    var opponentPlayer: Player!
    private var explosionTextures: [AnyObject]!
    var playerId = "1"
    
    //Player Names
    var playerAName = "A"
    var playerBName = "B"
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        addPubnub()
        loadExplosion()
        physicsWorld.contactDelegate = self
        ownPlayer = createPlayerAt(CGPointMake(100, 200))
        opponentPlayer = createPlayerAt(CGPointMake(200, 200))
        self.addChild(ownPlayer)
        self.addChild(opponentPlayer)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            ownPlayer.shootBullet()
            client.publish("{\"id\":\"\(playerId)\",\"t\":\"S\",\"v\":\"0\"}", toChannel: "Channel-m5odp0zna", compressed: false, withCompletion: nil)
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
//        sprite.physicsBody?.dynamic = false
        sprite.physicsBody!.usesPreciseCollisionDetection = true
        sprite.physicsBody?.categoryBitMask = playerCategory
        sprite.physicsBody?.collisionBitMask = playerCategory | bulletCategory
        sprite.physicsBody?.contactTestBitMask =
            playerCategory | bulletCategory
        return sprite
    }
    
    //MARK- Movement functions
    func moveOwnPlayer(direction: PlayerMovement) {
        client.publish("{\"id\":\"\(playerId)\",\"t\":\"M\",\"v\":\"\(direction.rawValue)\"}", toChannel: "Channel-m5odp0zna", compressed: false, withCompletion: nil)
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
            if(firstBody.node?.name == "Bullet" && (firstBody.node as! Bullet).playerName != ownPlayer.playerName) {
                firstBody.node?.removeFromParent()
                playExplosion(contact.contactPoint)
            }
            else if(secondBody.node?.name == "Bullet" && (secondBody.node as! Bullet).playerName != ownPlayer.playerName) {
                secondBody.node?.removeFromParent()
                playExplosion(contact.contactPoint)
            }
        }
    }
    
    //MARK:- Pubnub
    
    var client : PubNub!
    var config : PNConfiguration!
    
    func addPubnub() {
        config = PNConfiguration(publishKey: "pub-c-85f450ad-16a7-4434-b5b0-fef7c11e6839", subscribeKey: "sub-c-40615bee-7599-11e5-9611-02ee2ddab7fe")
        client = PubNub.clientWithConfiguration(config)
        client.subscribeToChannels(["Channel-m5odp0zna"], withPresence: false)
        client.publish("Swift+PubNub!", toChannel: "Channel-m5odp0zna", compressed: false, withCompletion: nil)
        client.addListener(self)
    }
    
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        let dict = message?.data?.message as? [String: String]
        print(dict)
        if let playerId: String = dict?["id"]{
            if playerId != self.playerId {
                if let type: String = dict?["t"]{
                    if(type=="M") {
                        if let value: String = dict?["v"] {
                            opponentPlayer.move(PlayerMovement(rawValue: value.toInt()!)!)
                        }
                    }
                    if(type=="S") {
                        if let value: String = dict?["v"] {
                            opponentPlayer.shootBullet()
                        }
                    }
                    if(type=="R") {
                        if let value: String = dict?["v"] {
                            opponentPlayer.rotate(!value.toBool()!)
                        }
                    }
                    if(type=="C") {
                        opponentPlayer.health -= 10
                        if opponentPlayer.health <= 0 {
                            print("I Win")
                        }
                    }

                }
            }
        }
    }
}
