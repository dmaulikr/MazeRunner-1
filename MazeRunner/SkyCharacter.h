//
//  SkyCharacter.h
//  MazeRunner
//
//  Created by John Canfield on 8/4/14.
//  Copyright (c) 2014 Nimbler World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkyTunnel.h"

@interface SkyCharacter : NSObject

@property(strong,nonatomic) SkyTunnel *currentTunnel;
@property(nonatomic) unsigned tunnelPosition;

@end
