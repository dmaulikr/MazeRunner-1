//
//  SkyTunnel.h
//  MazeRunner
//
//  Created by John Canfield on 8/3/14.
//  Copyright (c) 2014 Nimbler World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

typedef enum {
    VERTICAL_TUNNEL,
    HORIZONTAL_TUNNEL
} TUNNEL_DIRECTION;

typedef enum {
    UP_DIRECTION,
    DOWN_DIRECTION,
    LEFT_DIRECTION,
    RIGHT_DIRECTION
} MOVE_DIRECTION;

@interface SkyTunnel : NSObject

@property(nonatomic) TUNNEL_DIRECTION direction;
@property(nonatomic) unsigned long length;
@property(nonatomic) CGPoint position;
@property(strong,nonatomic) NSMutableArray *connectingTunnels;  // Array of equal length of this tunnel.  Has either [NSNull null] or a connecting SkyTunnel object
@property(strong,nonatomic) NSMutableArray *connectingPositions;  // Array of equal length of this tunnel.  Has either [NSNull null] of the a NSNumber with the connecting position on the connecting tunnel
@property(strong,nonatomic) SKSpriteNode *tunnelSpriteNode;  // SpriteNode for the tunnel

+ (instancetype)tunnelWithDirection:(TUNNEL_DIRECTION)direction length:(unsigned)length;

- (CGSize)tunnelCGSize;

// Makes a connection between self and tunnel2 at the designated positions in each tunnel.
// Returns true if a connection was able to be made.
// Returns false otherwise.  It cannot make connection if positions are past bounds, a connection is already there,
// or if the two tunnels are of the same direction orientation.  
- (BOOL)makeConnectionWithTunnel:(SkyTunnel *)tunnel2
                  atSelfPosition:(unsigned)selfPosition
             withTunnel2Position:(unsigned)tunnel2Position;

// Returns nil if it is not possible to move in the specified direction
// Returns the tunnel the person is in if they are able to move in that direction
// Usually the tunnel returned will be self, but if they moved to a connected tunnel, the connected tunnel is returned
// If checkConnections is true, it will check for ability to move on connecting tunnels
- (SkyTunnel *)canMoveInDirection:(MOVE_DIRECTION)direction
                      forPosition:(unsigned long)position
                 checkConnections:(BOOL)checkConnections;

@end
