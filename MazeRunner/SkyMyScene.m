//
//  SkyMyScene.m
//  MazeRunner
//
//  Created by John Canfield on 8/3/14.
//  Copyright (c) 2014 Nimbler World, Inc. All rights reserved.
//

#import "SkyMyScene.h"
#import "UIConstants.h"

typedef enum {
    MOVE_UP,
    MOVE_DOWN,
    MOVE_LEFT,
    MOVE_RIGHT,
    NO_COMMAND
} TouchCommand;

@implementation SkyMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        [sprite setScale:0.10];
        [self addChild:sprite];
        self.character = sprite;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        TouchCommand command = [self commandForTouch:touch inNode:self];
        
        CGFloat move_x = 0;
        CGFloat move_y = 0;
        
        if (command == MOVE_UP) {
            move_y = -30;
        }
        else if (command == MOVE_DOWN) {
            move_y = 30;
        }
        else if (command == MOVE_LEFT) {
            move_x =-30;
        }
        else if (command == MOVE_RIGHT){
            move_x =30;
        }
        
        if (move_x != 0 || move_y != 0) {
            SKAction *action = [SKAction moveByX:move_x y:move_y duration:MOVE_TIME];
            [self.character runAction:action];
        }

    }
}

-(TouchCommand)commandForTouch:(UITouch *)touch inNode:(SKNode *)node
{
    
    CGPoint location = [touch locationInNode:node];

    CGRect frame = node.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    if (location.y/height < TOUCH_UP_DOWN_PERCENTAGE) {
        return MOVE_UP;
    }
    else if (location.y/height > (1 - TOUCH_UP_DOWN_PERCENTAGE)) {
        return MOVE_DOWN;
    }
    else if (location.x/width < TOUCH_LEFT_RIGHT_PERCENTAGE) {
        return MOVE_LEFT;
    }
    else if (location.x/width > (1 - TOUCH_LEFT_RIGHT_PERCENTAGE)) {
        return MOVE_RIGHT;
    }
    return NO_COMMAND;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
