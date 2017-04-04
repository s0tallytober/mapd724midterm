//
//  Button.swift
//  Assignment3
//
//  Created by Willian Campos (300879280) on 2017-03-28.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
// This represents the buttons of slot machine.

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    
    private let action: () -> Void
    private var enabled = true
    
    init(name: String, action: @escaping () -> Void) {
        self.action = action
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = name
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Allows to enable / disable one button.
    // It also switches the image based on such state.
    func enable(_ enabled: Bool) {
        if (self.enabled != enabled) {
            self.enabled = enabled
            texture = SKTexture(imageNamed: enabled ? name! : name! + "-disabled")
        }
    }
    
    // Detects touches on this button. Invokes the specified action when touched and enabled
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (enabled) {
            scene!.run(SKAction.playSoundFileNamed("machine_button", waitForCompletion: false))
            action()
        } else {
            scene!.run(SKAction.playSoundFileNamed("disabled_button", waitForCompletion: false))
        }
    }
    
    
    
}
