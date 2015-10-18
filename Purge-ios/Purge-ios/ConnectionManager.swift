//
//  ConnectionManager.swift
//  CardsAgainst
//
//  Created by JP Simard on 11/2/14.
//  Copyright (c) 2014 JP Simard. All rights reserved.
//

import Foundation
import PeerKit
import MultipeerConnectivity

protocol MPCSerializable {
    var mpcSerialized: NSData { get }
    init(mpcSerialized: NSData)
}

enum Event: String {
    case StartGame = "StartGame",
    Answer = "Answer",
    CancelAnswer = "CancelAnswer",
    Vote = "Vote",
    NextCard = "NextCard",
    EndGame = "EndGame"
}

struct ConnectionManager {
    
    // MARK: Properties

}