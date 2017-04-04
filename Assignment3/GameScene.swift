//
//  GameScene.swift
//  Assignment3
//
//  Created by Willian Campos (300879280) on 2017-03-28.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
// This is the scene of the slot machine. It provides the UI for the game.

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SlotMachineManagerDelegate {
    
    private var slotNodes: [SKSpriteNode] = []
    private var manager: SlotMachineManager!
    
    private var creditNode: SKLabelNode!
    private var betNode: SKLabelNode!
    private var paidNode: SKLabelNode!
    private var messageNode: SKLabelNode!
    private var jackpotNode: SKLabelNode!
    private var resetNode: Button!
    private var bet1Node: Button!
    private var bet5Node: Button!
    private var bet50Node: Button!
    private var spinNode: Button!
    
    // Initialize the screen adding the nodes and their initial states
    // It also preload the sounds used during the game
    override func didMove(to view: SKView) {
        let selfSize = self.size
        
        manager = SlotMachineManager(self)
        
        let machineNode = SKSpriteNode(imageNamed: "slotmachine")
        self.addChild(machineNode)
        
        self.backgroundColor = UIColor.white
        
        let slot1Node = SKSpriteNode(imageNamed: "seven")
        slot1Node.zPosition = 1
        slot1Node.position = CGPoint(x: slot1Node.position.x, y: slot1Node.position.y - 50)
        self.addChild(slot1Node)
        
        
        let slot2Node = SKSpriteNode(imageNamed: "seven")
        slot2Node.zPosition = 1
        slot2Node.position = CGPoint(x: slot1Node.position.x - 220, y: slot1Node.position.y)
        self.addChild(slot2Node)
        
        
        let slot3Node = SKSpriteNode(imageNamed: "seven")
        slot3Node.zPosition = 1
        slot3Node.position = CGPoint(x: slot1Node.position.x + 218, y: slot1Node.position.y)
        self.addChild(slot3Node)
        
        slotNodes.append(slot2Node)
        slotNodes.append(slot1Node)
        slotNodes.append(slot3Node)
        
        let turnOffNode = Button(name: "turn_off", action: self.turnOff)
        turnOffNode.zPosition = 1
        turnOffNode.scale(to: CGSize(width: selfSize.width / 8, height: selfSize.width / 8))
        turnOffNode.anchorPoint = CGPoint(x: 0, y: 0)
        turnOffNode.position = CGPoint(x: selfSize.width / 2 - turnOffNode.size.width - 20, y: selfSize.height / 2 - turnOffNode.size.height - 20 )
        self.addChild(turnOffNode)
        
        resetNode = Button(name: "reset", action: manager.reset)
        resetNode.zPosition = 1
        resetNode.position = CGPoint(x: machineNode.position.x - 265, y: machineNode.position.y - 385)
        self.addChild(resetNode)
        
        bet1Node = Button(name: "bet1", action: self.bet1)
        bet1Node.zPosition = 1
        bet1Node.setScale(1.75)
        bet1Node.position = CGPoint(x: machineNode.position.x - 132.5, y: machineNode.position.y - 385)
        self.addChild(bet1Node)
        
        bet5Node = Button(name: "bet5", action: self.bet5)
        bet5Node.zPosition = 1
        bet5Node.setScale(1.75)
        bet5Node.position = CGPoint(x: machineNode.position.x, y: machineNode.position.y - 385)
        self.addChild(bet5Node)
        
        bet50Node = Button(name: "bet50", action: self.bet50)
        bet50Node.zPosition = 1
        bet50Node.setScale(1.75)
        bet50Node.position = CGPoint(x: machineNode.position.x + 132.5, y: machineNode.position.y - 385)
        self.addChild(bet50Node)
        
        spinNode = Button(name: "spin", action: manager.spin)
        spinNode.zPosition = 1
        spinNode.position = CGPoint(x: machineNode.position.x + 265, y: machineNode.position.y - 385)
        self.addChild(spinNode)
        spinNode.enable(false)
        
        messageNode = SKLabelNode(text: "SPIN TO WIN")
        messageNode.color = UIColor.white
        messageNode.zPosition = 1
        messageNode.position = CGPoint(x: machineNode.position.x + 5, y: machineNode.position.y + 165)
        self.addChild(messageNode)
        
        creditNode = SKLabelNode(text: "1000")
        creditNode.zPosition = 1
        creditNode.position = CGPoint(x: machineNode.position.x - 210, y: machineNode.position.y - 242.5)
        self.addChild(creditNode)
        
        betNode = SKLabelNode(text: "0")
        betNode.zPosition = 1
        betNode.position = CGPoint(x: machineNode.position.x, y: machineNode.position.y - 242.5)
        self.addChild(betNode)
        
        paidNode = SKLabelNode(text: "0")
        paidNode.zPosition = 1
        paidNode.position = CGPoint(x: machineNode.position.x + 210, y: machineNode.position.y - 242.5)
        self.addChild(paidNode)
        
        jackpotNode = SKLabelNode(text: "Jackpot: 5000")
        jackpotNode.zPosition = 1
        jackpotNode.color = UIColor.black
        jackpotNode.fontColor = UIColor.black
        jackpotNode.fontSize = 60
        jackpotNode.position = CGPoint(x: 0, y: selfSize.height / 2 - 90 )
        
        self.addChild(jackpotNode)
        
        
        preloadSounds()
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        manager.update(updateSlot(_:_:))
    }
    
    // Update a wheel with the new image
    private func updateSlot(_ slotNumber: Int, _ slotImage: String) {
        slotNodes[slotNumber].texture = SKTexture(imageNamed: slotImage)
    }
    
    // Preload the sounds used during the game
    private func preloadSounds() {
        let sounds = ["machine_button", "disabled_button", "spinning"]
        for sound in sounds {
            do {
                let path = Bundle.main.path(forResource: sound, ofType: "mp3")!
                let url = URL(fileURLWithPath: path)
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            } catch {
                print("It was not possible to load the sounds")
            }
        }
    }
    
    // Closes the app
    private func turnOff() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    // Invoked when user clicks on bet 1 button
    private func bet1() {
        manager.bet(amount: 1)
    }
    
    // Invoked when user clicks on bet 5 button
    private func bet5() {
        manager.bet(amount: 5)
    }
    
    // Invoked when user clicks on bet 50 button
    private func bet50() {
        manager.bet(amount: 50)
    }
    
    // Returns this game scene (used in manager)
    func getScene() -> SKScene {
        return self
    }
    
    // Update the credit value on screen
    func updateCredit(amount: Int) {
        creditNode.text = String(amount)
    }
    
    // Update the bet value on screen
    func updateBet(amount: Int) {
        betNode.text = String(amount)
    }
    
    // Update the paid value on screen
    func updatePaid(amount: Int) {
        paidNode.text = String(amount)
    }
    
    // Update the jackpot value on screen
    func updateJackpot(amount: Int) {
        jackpotNode.text = "Jackpot: \(amount)"
    }
    
    // Update the message on screen
    func updateMessage(message: String) {
        messageNode.text = message
    }
    
    
    // The following methods allows the manager to enable / disable the buttons
    func enableReset(enable: Bool) {
        resetNode.enable(enable)
        
    }
    
    func enableBet1(enable: Bool) {
        bet1Node.enable(enable)
        
    }
    
    func enableBet5(enable: Bool) {
        bet5Node.enable(enable)
    }
    
    func enableBet50(enable: Bool) {
        bet50Node.enable(enable)
    }
    
    func enableSpin(enable: Bool) {
        spinNode.enable(enable)
    }
}
