//
//  GameScene.swift
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //Nodes
    var ownPlayer: Player!
    var opponentPlayer: Player!
    
    //Player Names
    var playerAName = "A"
    var playerBName = "B"
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        ownPlayer = createPlayerAt(CGPointMake(520, 200))
        opponentPlayer = createPlayerAt(CGPointMake(520, 400))
        self.addChild(ownPlayer)
        self.addChild(opponentPlayer)
        ConnectionManager.start()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        

        let attr = MPCAttributedString(attributedString: NSAttributedString(string: "What is this"))
        ConnectionManager.sendEvent(Event.Answer, object: ["Aashish": attr] , toPeers: ConnectionManager.allPlayers)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //MARK- Spawn functions
    func createPlayerAt(location: CGPoint) -> Player{
        let sprite = Player(imageNamed:"Spaceship")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = location
        
        return sprite;
    }
    
    
    // MARK: Multipeer
    
    private func setupMultipeerEventHandlers() {
        // Answer
        ConnectionManager.onEvent(.Answer) { peer, object in
            println("Answer event")
            println(object)
            }
        }
}
