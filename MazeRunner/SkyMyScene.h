//
//  SkyMyScene.h
//  MazeRunner
//

//  Copyright (c) 2014 Nimbler World, Inc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SkyTunnel.h"
#import "SkyCharacter.h"

@interface SkyMyScene : SKScene

@property(strong, nonatomic) SkyTunnel *tunnel1;
@property(strong, nonatomic) SkyCharacter *spaceship;
@property(strong, nonatomic) SKSpriteNode *spaceshipSprite;
@property(strong, nonatomic) SKLabelNode *timerText;
@property(nonatomic) CFTimeInterval startTime;
@property(nonatomic) CFTimeInterval currentTime;
@property(nonatomic) CFTimeInterval endTime;
@end
