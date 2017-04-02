//
//  SlotMachineManager.swift
//  Assignment3
//
//  Created by Willian Campos on 2017-04-01.
//  Copyright © 2017 Willian Campos. All rights reserved.
//

import Foundation
import SpriteKit

protocol SlotMachineManagerDelegate {
    
    func getScene() -> SKScene
    
    func updateCredit(amount : Int)
    func updateBet(amount : Int)
    func updatePaid(amount : Int)
    func updateMessage(message : String)
    
    func enableBet1(enable: Bool)
    func enableBet5(enable: Bool)
    func enableBet50(enable: Bool)
    func enableSpin(enable: Bool)
    
}
class SlotMachineManager {
    
    var playerMoney = 1000;
    var winnings = 0;
    var jackpot = 5000;
    var playerBet = 0;
    
    var grapes = 0;
    var bananas = 0;
    var oranges = 0;
    var cherries = 0;
    var bars = 0;
    var bells = 0;
    var sevens = 0;
    var blanks = 0;
    
    
    var spinning: Bool = false
    var spinningWheel0: Bool = false
    var spinningWheel1: Bool = false
    var spinningWheel2: Bool = false
    var spinningStart: TimeInterval!
    var spinningResult: [String]!
    
    let delegate: SlotMachineManagerDelegate
    
    init(_ delegate: SlotMachineManagerDelegate) {
        self.delegate = delegate
    }
    
    func reset() {
        playerMoney = playerMoney + playerBet
        playerBet = 0
        delegate.updateCredit(amount: playerMoney)
        delegate.updateBet(amount: playerBet)
        updateBetButtons()
        delegate.enableSpin(enable: false)
    }
    
    func bet(amount: Int) {
        if (amount > playerMoney) {
            delegate.updateMessage(message: "NO CREDIT!")
            return
        }
        
        playerMoney = playerMoney - amount
        playerBet = playerBet + amount
        delegate.updateCredit(amount: playerMoney)
        delegate.updateBet(amount: playerBet)
        updateBetButtons()
        delegate.enableSpin(enable: true)
    }
    
    private func updateBetButtons() {
        var enableBet1 = true
        var enableBet5 = true
        var enableBet50 = true
        
        if (playerMoney < 1) {
            enableBet1 = false
            enableBet5 = false
            enableBet50 = false
        } else if (playerMoney < 5) {
            enableBet5 = false
            enableBet50 = false
        } else if (playerMoney < 50) {
            enableBet50 = false
        }
        
        delegate.enableBet1(enable: enableBet1)
        delegate.enableBet5(enable: enableBet5)
        delegate.enableBet50(enable: enableBet50)
    }
    
    /* Utility function to check if a value falls within a range of bounds */
    func checkRange(_ value: Int, _ lowerBounds: Int, _ upperBounds: Int) -> Bool {
        if (value >= lowerBounds && value <= upperBounds)
        {
            return true;
        }
        return false;
    }
    
    /* When this function is called it determines the betLine results.
     e.g. Bar - Orange - Banana */
    func spin() {
        if (spinning || playerBet == 0) {
            return
        }
        
        var betLine = [" ", " ", " "]
        
        
        for spin in 0...2 {
            let outCome = Int(arc4random_uniform(65)) + 1
            
            if (checkRange(outCome, 1, 27)) // 41.5% probability
            {
                betLine[spin] = "blank"
                blanks = blanks + 1
                continue
            }
            
            if (checkRange(outCome, 28, 37)) // 15.4% probability
            {
                betLine[spin] = "grape"
                grapes = grapes + 1
                continue
            }
            
            if (checkRange(outCome, 38, 46)) // 13.8% probability
            {
                betLine[spin] = "banana"
                bananas = bananas + 1
                continue
            }
            if (checkRange(outCome, 47, 54)) // 12.3% probability
            {
                betLine[spin] = "orange"
                oranges = oranges + 1
                continue
            }
            
            if (checkRange(outCome, 55, 59)) //  7.7% probability
            {
                betLine[spin] = "cherry"
                cherries = cherries + 1
                continue
            }
            
            if (checkRange(outCome, 60, 62)) //  4.6% probability
            {
                betLine[spin] = "bar"
                bars = bars + 1
                continue
            }
            
            if (checkRange(outCome, 63, 64)) //  3.1% probability
            {
                betLine[spin] = "bell"
                bells = bells + 1
                continue
            }
            
            betLine[spin] = "seven"
            sevens = sevens + 1
        }
        spinning = true
        spinningWheel0 = true
        spinningWheel1 = true
        spinningWheel2 = true
        spinningStart = NSDate.timeIntervalSinceReferenceDate
        delegate.getScene().run(SKAction.playSoundFileNamed("spinning", waitForCompletion: false))
        spinningResult = betLine;
        delegate.updatePaid(amount: 0)
        delegate.enableSpin(enable: false)
    }
    
    /* This function calculates the player's winnings, if any */
    func determineWinnings()
    {
        if (blanks == 0)
        {
            if (grapes == 3) {
                winnings = playerBet * 10;
            }
            else if(bananas == 3) {
                winnings = playerBet * 20;
            }
            else if (oranges == 3) {
                winnings = playerBet * 30;
            }
            else if (cherries == 3) {
                winnings = playerBet * 40;
            }
            else if (bars == 3) {
                winnings = playerBet * 50;
            }
            else if (bells == 3) {
                winnings = playerBet * 75;
            }
            else if (sevens == 3) {
                winnings = playerBet * 100;
            }
            else if (grapes == 2) {
                winnings = playerBet * 2;
            }
            else if (bananas == 2) {
                winnings = playerBet * 2;
            }
            else if (oranges == 2) {
                winnings = playerBet * 3;
            }
            else if (cherries == 2) {
                winnings = playerBet * 4;
            }
            else if (bars == 2) {
                winnings = playerBet * 5;
            }
            else if (bells == 2) {
                winnings = playerBet * 10;
            }
            else if (sevens == 2) {
                winnings = playerBet * 20;
            }
            else if (sevens == 1) {
                winnings = playerBet * 5;
            }
            else {
                winnings = playerBet * 1;
            }
            playerMoney = playerMoney + winnings
            delegate.updateCredit(amount: playerMoney)
            delegate.updatePaid(amount: winnings)
            delegate.updateMessage(message: "YOU WON!!!")
        }
        else
        {
            delegate.updateMessage(message: "TRY AGAIN!!!")
        }
        playerBet = 0
        delegate.updateBet(amount: 0)
        updateBetButtons()
        grapes = 0;
        bananas = 0;
        oranges = 0;
        cherries = 0;
        bars = 0;
        bells = 0;
        sevens = 0;
        blanks = 0;
        
        
    }
    
    let fruitsArray = ["grape", "banana", "orange", "cherry", "bar", "bell", "seven", "blank"]
    
    func update(_ updateFunction: (Int, String) -> Void) {
        if (spinning) {
            let spinningDuration = NSDate.timeIntervalSinceReferenceDate - spinningStart
            if (spinningDuration >= 2.75) {
                updateFunction(0, spinningResult[0])
                updateFunction(1, spinningResult[1])
                updateFunction(2, spinningResult[2])
                spinning = false
                spinningStart = nil
                spinningResult = nil
                
            } else {
                if (spinningDuration >= 1.0) {
                    if (spinningWheel0) {
                        updateFunction(0, spinningResult[0])
                        spinningWheel0 = false
                    }
                } else {
                    updateWithRandom(wheel: 0, function: updateFunction)
                }
                
                if (spinningDuration >= 1.7) {
                    if (spinningWheel1) {
                        updateFunction(1, spinningResult[1])
                        spinningWheel1 = false
                    }
                } else {
                    updateWithRandom(wheel: 1, function: updateFunction)
                }
                
                if (spinningDuration >= 2.2) {
                    if (spinningWheel2) {
                        updateFunction(2, spinningResult[2])
                        spinningWheel2 = false
                        determineWinnings()
                    }
                } else {
                    updateWithRandom(wheel: 2, function: updateFunction)
                }
            }
        }
    }
    
    private func updateWithRandom(wheel: Int, function: (Int, String) -> Void) {
        function(wheel, fruitsArray[Int(arc4random_uniform(8))])
    }
    
}
