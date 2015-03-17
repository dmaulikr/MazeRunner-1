//
//  SkyMyScene.swift
//  MazeRunner
//
//  Created by John Canfield on 3/15/15.
//  Copyright (c) 2015 Nimbler World, Inc. All rights reserved.
//

import Foundation
import SpriteKit

// Enumeration -- defines a variable class with five different values
enum TouchCommand {
    case MOVE_UP,
    MOVE_DOWN,
    MOVE_LEFT,
    MOVE_RIGHT,
    NO_COMMAND
}

class SkyMyScene: SKScene
{
    /* Properties */
    var character: SKSpriteNode
    
    /* Initializer method */
    override init(size:CGSize) {
        var sprite = SKSpriteNode(imageNamed: "Spaceship")  // use Spaceship.png file for the image of the sprite
        self.character = sprite
        super.init(size: size)
        self.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.3, alpha:1.0)
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        sprite.setScale(0.10)
        self.addChild(sprite)   // Make sprite visible
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Callback function for when a touch begins
    // This is where we move our character
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let command: TouchCommand = commandForTouch(touch as UITouch, node:self)
            let moveDistance = 30
            
            var move_x:CGFloat = 0
            var move_y:CGFloat = 0
            
            // Here is where you need to insert you code to set how much 
            // to move in the x direction (left / right) or the y direction (up / down)
            // move_x is the variable for the number of pixels you move left or right
            // move_y is the variable for the number of pixels you move up or down
            //
            
            if command == TouchCommand.MOVE_UP {
                move_y = 30
                self.character.zRotation = 0  // Extra credit, adjust rotation
            }
            if command == TouchCommand.MOVE_DOWN {
                move_y = -30
                self.character.zRotation = CGFloat(M_PI)  // Extra credit, adjust rotation
            }
            if command == TouchCommand.MOVE_LEFT {
                move_x = -30
                self.character.zRotation = CGFloat(M_PI * 0.5)  // Extra credit, adjust rotation
            }
            if command == TouchCommand.MOVE_RIGHT {
                move_x = 30
                self.character.zRotation = CGFloat(M_PI * 1.5)  // Extra credit, adjust rotation
            }
            // End Lesson 1 required code
            
            if (move_x != 0 || move_y != 0) {
                let action:SKAction = SKAction.moveByX(move_x, y: move_y, duration: 0.25)
                self.character.runAction(action)
            }
            
        }
    }
    
    // Figures out which way the user wants to move the character based on which 
    // edge of the screen the user touched.
    func commandForTouch(touch:UITouch, node:SKNode) -> TouchCommand {
        let location:CGPoint = touch.locationInNode(node)
        let frame:CGRect = node.frame
        let height = CGRectGetHeight(frame)
        let width = CGRectGetWidth(frame)
        
        if (location.y/height < 0.25) {
            return TouchCommand.MOVE_DOWN
        }
        else if (location.y/height > (1 - 0.25)) {
            return TouchCommand.MOVE_UP
        }
        else if (location.x/width < 0.25) {
            return TouchCommand.MOVE_LEFT
        }
        else if (location.x/width > (1 - 0.25)) {
            return TouchCommand.MOVE_RIGHT
        }
        return TouchCommand.NO_COMMAND
    }
}