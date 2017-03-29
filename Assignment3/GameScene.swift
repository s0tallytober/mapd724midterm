//
//  GameScene.swift
//  Assignment3
//
//  Created by Willian Campos on 2017-03-28.
//  Copyright © 2017 Willian Campos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        let machineNode = SKSpriteNode(imageNamed: "slotmachine")
        self.addChild(machineNode)
        
        self.backgroundColor = UIColor.white
        
        let slot1Node = SKSpriteNode(imageNamed: "banana")
        slot1Node.zPosition = 1
        slot1Node.position = CGPoint(x: slot1Node.position.x, y: slot1Node.position.y - 50)
        self.addChild(slot1Node)
        
        let slot2Node = SKSpriteNode(imageNamed: "banana")
        slot2Node.zPosition = 1
        slot2Node.position = CGPoint(x: slot1Node.position.x - 220, y: slot1Node.position.y)
        self.addChild(slot2Node)
        
        let slot3Node = SKSpriteNode(imageNamed: "banana")
        slot3Node.zPosition = 1
        slot3Node.position = CGPoint(x: slot1Node.position.x + 218, y: slot1Node.position.y)
        self.addChild(slot3Node)
        
        let resetNode = SKSpriteNode(imageNamed: "reset")
        resetNode.zPosition = 1
        resetNode.position = CGPoint(x: machineNode.position.x - 265, y: machineNode.position.y - 385)
        self.addChild(resetNode)
        
        let bet1Node = SKSpriteNode(imageNamed: "bet1")
        bet1Node.zPosition = 1
        bet1Node.setScale(1.75)
        bet1Node.position = CGPoint(x: machineNode.position.x - 132.5, y: machineNode.position.y - 385)
        self.addChild(bet1Node)
        
        let bet5Node = SKSpriteNode(imageNamed: "bet5")
        bet5Node.zPosition = 1
        bet5Node.setScale(1.75)
        bet5Node.position = CGPoint(x: machineNode.position.x, y: machineNode.position.y - 385)
        self.addChild(bet5Node)
        
        let bet50Node = SKSpriteNode(imageNamed: "bet50")
        bet50Node.zPosition = 1
        bet50Node.setScale(1.75)
        bet50Node.position = CGPoint(x: machineNode.position.x + 132.5, y: machineNode.position.y - 385)
        self.addChild(bet50Node)
        
        let spinNode = SKSpriteNode(imageNamed: "spin")
        spinNode.zPosition = 1
        spinNode.position = CGPoint(x: machineNode.position.x + 265, y: machineNode.position.y - 385)
        self.addChild(spinNode)
        
        let messageNode = SKLabelNode(text: "SPIN TO WIN")
        messageNode.color = UIColor.white
        messageNode.zPosition = 1
        messageNode.position = CGPoint(x: machineNode.position.x, y: machineNode.position.y + 165)
        self.addChild(messageNode)
        
        let creditNode = SKLabelNode(text: "100")
        creditNode.zPosition = 1
        creditNode.position = CGPoint(x: machineNode.position.x - 210, y: machineNode.position.y - 242.5)
        self.addChild(creditNode)
        
        let betNode = SKLabelNode(text: "0")
        betNode.zPosition = 1
        betNode.position = CGPoint(x: machineNode.position.x, y: machineNode.position.y - 242.5)
        self.addChild(betNode)
        
        let paidNode = SKLabelNode(text: "0")
        paidNode.zPosition = 1
        paidNode.position = CGPoint(x: machineNode.position.x + 210, y: machineNode.position.y - 242.5)
        self.addChild(paidNode)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
