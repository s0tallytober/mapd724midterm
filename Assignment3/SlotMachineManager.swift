//
//  SlotMachineManager.swift
//  Assignment3
//
//  Created by Willian Campos on 2017-04-01.
//  Copyright © 2017 Willian Campos. All rights reserved.
//

import Foundation

class SlotMachineManager {
    
    var playerMoney = 1000;
    var winnings = 0;
    var jackpot = 5000;
    var turn = 0;
    var playerBet = 0;
    var winNumber = 0;
    var lossNumber = 0;
    var spinResult: [String] = [];
    var fruits = "";
    var winRatio = 0;
    
    var grapes = 0;
    var bananas = 0;
    var oranges = 0;
    var cherries = 0;
    var bars = 0;
    var bells = 0;
    var sevens = 0;
    var blanks = 0;
    
    
    var spinning: Bool = false
    var spinningStart: TimeInterval!
    
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
    func spin() -> [String] {
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
        spinningStart = NSDate.timeIntervalSinceReferenceDate
        return betLine;
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
            winNumber = winNumber + 1;
            //showWinMessage();
        }
        else
        {
            lossNumber = lossNumber + 1;
            //showLossMessage();
        }
        
    }
    
    let fruitsArray = ["grape", "banana", "orange", "cherry", "bar", "bell", "seven", "blank"]
    
    func update(_ updateFunction: ([String]) -> Void) {
        if (spinning) {
            var slotImages: [String] = []
            if (NSDate.timeIntervalSinceReferenceDate - spinningStart >= 3) {
                slotImages = spin()
                spinning = false
                spinningStart = nil
            } else {
                slotImages.append(fruitsArray[Int(arc4random_uniform(8))])
                slotImages.append(fruitsArray[Int(arc4random_uniform(8))])
                slotImages.append(fruitsArray[Int(arc4random_uniform(8))])
            }
            
            updateFunction(slotImages)
        }
    }
    
}
