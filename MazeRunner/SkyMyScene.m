//
//  SkyMyScene.m
//  MazeRunner
//
//  Created by John Canfield on 8/3/14.
//  Copyright (c) 2014 Nimbler World, Inc. All rights reserved.
//

#import "SkyMyScene.h"
#import "UIConstants.h"
#import "SkyTunnel.h"
#import "Logging.h"

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
        
        /* Set-up timer */
        self.startTime = 0.0;
        self.timerText = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.timerText.fontColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.timerText.fontSize = 14.0;
        self.timerText.text = @"15.0";
        self.timerText.position = CGPointMake(CGRectGetMidX(self.frame), 40.0);
        [self addChild:self.timerText];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SkyTunnel *tunnel1 = [SkyTunnel tunnelWithDirection:HORIZONTAL_TUNNEL length:5];
        tunnel1.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));  // set tunnel 1 in middle of screen
        [self addChild:[tunnel1 tunnelSpriteNode]];
        self.tunnel1 = tunnel1;
        
        SkyTunnel *tunnel2 = [SkyTunnel tunnelWithDirection:VERTICAL_TUNNEL length:5];
        [tunnel1 makeConnectionWithTunnel:tunnel2 atSelfPosition:0 withTunnel2Position:1];
        [self addChild:[tunnel2 tunnelSpriteNode]];

        SkyTunnel *tunnel3 = [SkyTunnel tunnelWithDirection:HORIZONTAL_TUNNEL length:4];
        [tunnel2 makeConnectionWithTunnel:tunnel3 atSelfPosition:2 withTunnel2Position:1];
        [self addChild:[tunnel3 tunnelSpriteNode]];
        
        SkyTunnel *tunnel4 = [SkyTunnel tunnelWithDirection:VERTICAL_TUNNEL length:6];
        [tunnel1 makeConnectionWithTunnel:tunnel4 atSelfPosition:4 withTunnel2Position:5];
        [self addChild:[tunnel4 tunnelSpriteNode]];
        
        self.spaceship = [[SkyCharacter alloc] init];
        self.spaceship.currentTunnel = tunnel1;
        self.spaceship.tunnelPosition = 2;  // middle of tunnel1
        
        SKSpriteNode *spaceshipSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        SKSpriteNode *hourglassSprite= [SKSpriteNode spriteNodeWithImageNamed:@"Blue hourglass"];
        hourglassSprite.position = CGPointMake(248,58);
        [hourglassSprite setScale:0.15];
        [self addChild:hourglassSprite];
        
        spaceshipSprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        [spaceshipSprite setScale:0.10];
        [self addChild:spaceshipSprite];
        self.spaceshipSprite = spaceshipSprite;


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
            SkyTunnel *newtunnel = [self.spaceship.currentTunnel canMoveInDirection:UP_DIRECTION
                                                        forPosition:self.spaceship.tunnelPosition
                                                   checkConnections:true];
            if (newtunnel) {
                if (newtunnel != self.spaceship.currentTunnel) {
                    self.spaceship.tunnelPosition = [[self.spaceship.currentTunnel.connectingPositions
                                                      objectAtIndex:self.spaceship.tunnelPosition] integerValue];
                    self.spaceship.currentTunnel = newtunnel;
                }
                self.spaceship.tunnelPosition = self.spaceship.tunnelPosition + 1;
                move_y = MOVE_DISTANCE;
                [self.spaceshipSprite setZRotation:0.0];
            }
        }
        else if (command == MOVE_DOWN) {
            SkyTunnel *newtunnel = [self.spaceship.currentTunnel canMoveInDirection:DOWN_DIRECTION
                                                        forPosition:self.spaceship.tunnelPosition
                                                   checkConnections:true];
            if (newtunnel) {
                if (newtunnel != self.spaceship.currentTunnel) {
                    self.spaceship.tunnelPosition = [[self.spaceship.currentTunnel.connectingPositions
                                                      objectAtIndex:self.spaceship.tunnelPosition] integerValue];
                    self.spaceship.currentTunnel = newtunnel;
                }
                self.spaceship.tunnelPosition = self.spaceship.tunnelPosition - 1;
                move_y = -MOVE_DISTANCE;
                [self.spaceshipSprite setZRotation:M_PI];
            }
        }
        else if (command == MOVE_LEFT) {
            SkyTunnel *newtunnel = [self.spaceship.currentTunnel canMoveInDirection:LEFT_DIRECTION
                                                        forPosition:self.spaceship.tunnelPosition
                                                   checkConnections:true];
            if (newtunnel) {
                if (newtunnel != self.spaceship.currentTunnel) {
                    self.spaceship.tunnelPosition = [[self.spaceship.currentTunnel.connectingPositions
                                                      objectAtIndex:self.spaceship.tunnelPosition] integerValue];
                    self.spaceship.currentTunnel = newtunnel;
                }
                self.spaceship.tunnelPosition = self.spaceship.tunnelPosition - 1;
                move_x =-MOVE_DISTANCE;
                [self.spaceshipSprite setZRotation:(M_PI/2)];
            }
        }
        else if (command == MOVE_RIGHT){
            SkyTunnel *newtunnel = [self.spaceship.currentTunnel canMoveInDirection:RIGHT_DIRECTION
                                                        forPosition:self.spaceship.tunnelPosition
                                                   checkConnections:true];
            if (newtunnel) {
                if (newtunnel != self.spaceship.currentTunnel) {
                    self.spaceship.tunnelPosition = [[self.spaceship.currentTunnel.connectingPositions
                                                      objectAtIndex:self.spaceship.tunnelPosition] integerValue];
                    self.spaceship.currentTunnel = newtunnel;
                }
                self.spaceship.tunnelPosition = self.spaceship.tunnelPosition + 1;
                move_x =MOVE_DISTANCE;
                [self.spaceshipSprite setZRotation:(M_PI*1.5)];
            }
        }
        
        if (move_x != 0 || move_y != 0) {
            SKAction *action = [SKAction moveByX:move_x y:move_y duration:MOVE_TIME];
            [self.spaceshipSprite runAction:action];
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
        return MOVE_DOWN;
    }
    else if (location.y/height > (1 - TOUCH_UP_DOWN_PERCENTAGE)) {
        return MOVE_UP;
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
    if (self.startTime == 0) {
        self.startTime = currentTime;
        self.endTime = currentTime + TIMER_SECONDS;
    }
    self.currentTime = currentTime;
    self.timerText.text = [NSString stringWithFormat:@"%2.1f",(self.endTime - self.currentTime)];
}

@end
