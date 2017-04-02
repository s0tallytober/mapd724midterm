//
//  Button.swift
//  Assignment3
//
//  Created by Willian Campos on 2017-04-02.
//  Copyright © 2017 Willian Campos. All rights reserved.
//

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
    
    func enable(_ enabled: Bool) {
        if (self.enabled != enabled) {
            self.enabled = enabled
            texture = SKTexture(imageNamed: enabled ? name! : name! + "-disabled")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (enabled) {
            scene!.run(SKAction.playSoundFileNamed("machine_button", waitForCompletion: false))
            action()
        } else {
            scene!.run(SKAction.playSoundFileNamed("disabled_button_2", waitForCompletion: false))
        }
    }
    
    
    
}
