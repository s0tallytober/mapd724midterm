//
//  SlotMachineManager.swift
//  Assignment3
//
//  Created by Willian Campos (300879280) on 2017-03-28.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
// This is the manager of slot machine. It has the business logic and it is responsable for maintaining the correct state of the game.

import Foundation
import SpriteKit

protocol SlotMachineManagerDelegate {
    
    func getScene() -> SKScene
    
    func updateCredit(amount : Int)
    func updateBet(amount : Int)
    func updatePaid(amount : Int)
    func updateJackpot(amount : Int)
    func updateMessage(message : String)
    
    func enableReset(enable: Bool)
    func enableBet1(enable: Bool)
    func enableBet5(enable: Bool)
    func enableBet50(enable: Bool)
    func enableSpin(enable: Bool)
    
}
class SlotMachineManager {
    
    private let fruitsArray = ["grape", "banana", "orange", "cherry", "bar", "bell", "seven", "blank"]
    
    private var playerMoney = 1000;
    private var winnings = 0;
    private var jackpot = 5000;
    private var playerBet = 0;
    
    private var grapes = 0;
    private var bananas = 0;
    private var oranges = 0;
    private var cherries = 0;
    private var bars = 0;
    private var bells = 0;
    private var sevens = 0;
    private var blanks = 0;
    
    
    private var spinning: Bool = false
    private var spinningWheel0: Bool = false
    private var spinningWheel1: Bool = false
    private var spinningWheel2: Bool = false
    private var spinningStart: TimeInterval!
    private var spinningResult: [String]!
    
    private let delegate: SlotMachineManagerDelegate
    
    init(_ delegate: SlotMachineManagerDelegate) {
        self.delegate = delegate
    }
    
    // Func invoked when user clicks on reset button
    func reset() {
        playerMoney = 1000
        jackpot = 5000
        playerBet = 0
        delegate.updateMessage(message: "SPIN TO WIN!!!")
        delegate.updateCredit(amount: playerMoney)
        delegate.updatePaid(amount: 0)
        delegate.updateJackpot(amount: jackpot)
        delegate.updateBet(amount: playerBet)
        updateBetButtons()
        delegate.enableSpin(enable: false)
    }
    
    // Func invoked when user clicks on bet buttons
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
    
    // Function for updating the bet buttons state through delegate
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
    
    // This function is invoked to simulate the spin
    // It "starts" the animation, through delegate updates the screen (so user cannot interact while spinning) and starts the spinning sound
    func spin() {
        // avoid invoking it when it is already spinning or there is no bet yet
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
        delegate.updateMessage(message: "...SPINNING...")
        delegate.updatePaid(amount: 0)
        delegate.enableSpin(enable: false)
        delegate.enableBet1(enable: false)
        delegate.enableBet5(enable: false)
        delegate.enableBet50(enable: false)
        delegate.enableReset(enable: false)
    }
    
    // This function calculates the player's winnings, if any
    // It also invokes the delegate to update the screen with the values
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
            var message = "YOU WON!!!"
            
            if checkJackpot() {
                message = "JACKPOT!!!"
                winnings += jackpot
                jackpot = 1000;
                delegate.updateJackpot(amount: jackpot)
            }
            playerMoney = playerMoney + winnings
            delegate.updateCredit(amount: playerMoney)
            delegate.updateMessage(message: message)
            delegate.updatePaid(amount: winnings)
        }
        else
        {
            delegate.updateMessage(message: "SPIN AGAIN!!!")
        }
        playerBet = 0
        delegate.updateBet(amount: 0)
        delegate.enableReset(enable: true)
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
    
    // This function is responsible for check it user won the jackpot
    private func checkJackpot () -> Bool {
        let jackPotTry = arc4random_uniform(51);
        let jackPotWin = arc4random_uniform(51);
        if (jackPotTry == jackPotWin) {
            return true
        }
        return false
    }
    
    // This function is invoked before rendering each frame
    func update(_ updateFunction: (Int, String) -> Void) {
        // 'spinning' true means that it should look like the wheels are spinning
        if (spinning) {
            // based on when spinning began, calculates the duration
            let spinningDuration = NSDate.timeIntervalSinceReferenceDate - spinningStart
            
            // based on duration, determines if each wheel should look like spinning
            if (spinningDuration >= 2.75) {
                // in this scenario, just reached the total "animation" duration.
                // so reset the "animation control" variables
                spinning = false
                spinningStart = nil
                spinningResult = nil
                
                //determine the winnings for this spin
                determineWinnings()
                
            } else {
                if (spinningDuration >= 1.0) {
                    if (spinningWheel0) {
                        // in this scenario, just reached the "animation" duration of the first wheel.
                        // so update the screen with the first wheel actual value and reset the "animation control" variable for such wheel
                        updateFunction(0, spinningResult[0])
                        spinningWheel0 = false
                    }
                } else {
                    // in this scenario, the wheel should look like spinning, updates it with a random value
                    updateWithRandom(wheel: 0, function: updateFunction)
                }
                
                if (spinningDuration >= 1.7) {
                    if (spinningWheel1) {
                        // in this scenario, just reached the "animation" duration of the second wheel.
                        // so update the screen with the second wheel actual value and reset the "animation control" variable for such wheel
                        updateFunction(1, spinningResult[1])
                        spinningWheel1 = false
                    }
                } else {
                    // in this scenario, the wheel should look like spinning, updates it with a random value
                    updateWithRandom(wheel: 1, function: updateFunction)
                }
                
                if (spinningDuration >= 2.2) {
                    if (spinningWheel2) {
                        // in this scenario, just reached the "animation" duration of the third wheel.
                        // so update the screen with the third wheel actual value and reset the "animation control" variable for such wheel
                        updateFunction(2, spinningResult[2])
                        spinningWheel2 = false
                    }
                } else {
                    // in this scenario, the wheel should look like spinning, updates it with a random value
                    updateWithRandom(wheel: 2, function: updateFunction)
                }
            }
        }
    }
    // use the given function to update the wheel with a random value
    private func updateWithRandom(wheel: Int, function: (Int, String) -> Void) {
        function(wheel, fruitsArray[Int(arc4random_uniform(8))])
    }
    
}
