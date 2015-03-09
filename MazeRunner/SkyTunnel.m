//
//  SkyTunnel.m
//  MazeRunner
//
//  Created by John Canfield on 8/3/14.
//  Copyright (c) 2014 Nimbler World, Inc. All rights reserved.
//

#import "SkyTunnel.h"
#import "UIConstants.h"
#import "Logging.h"

@implementation SkyTunnel

+ (instancetype)tunnelWithDirection:(TUNNEL_DIRECTION)direction length:(unsigned)length
{
    SkyTunnel *skyTunnel = [[SkyTunnel alloc] init];
    if (length < 1) {
        skyTunnel.length = 1;
    } else {
        skyTunnel.length = length;
    }
    skyTunnel.direction = direction;
    
    // Initialize connecting array with [NSNull null] as placeholders
    skyTunnel.connectingTunnels = [NSMutableArray arrayWithCapacity:length];
    skyTunnel.connectingPositions = [NSMutableArray arrayWithCapacity:length];
    for (int i=0; i<length; i++) {
        [skyTunnel.connectingTunnels addObject:[NSNull null]];
        [skyTunnel.connectingPositions addObject:[NSNull null]];
    }
    
    return skyTunnel;
}

- (CGSize)tunnelCGSize
{
    CGFloat height = 0.0;
    CGFloat width = 0.0;
    if (self.direction == VERTICAL_TUNNEL) {
        width = TUNNEL_WIDTH - (TUNNEL_BOUNDARY_BUFFER * 2);
        height = TUNNEL_WIDTH + MOVE_DISTANCE * (self.length - 1) - (TUNNEL_BOUNDARY_BUFFER * 2);
    } else {
        height = TUNNEL_WIDTH - (TUNNEL_BOUNDARY_BUFFER * 2);
        width = TUNNEL_WIDTH + MOVE_DISTANCE * (self.length - 1) - (TUNNEL_BOUNDARY_BUFFER * 2);
    }
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (SKSpriteNode *)tunnelSpriteNode
{
    if (_tunnelSpriteNode == nil) {
        UIColor *tunnelColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        CGSize tunnelSize = [self tunnelCGSize];
        _tunnelSpriteNode = [SKSpriteNode spriteNodeWithColor:tunnelColor size:tunnelSize];
        _tunnelSpriteNode.position = self.position;
    }
    return _tunnelSpriteNode;
}

// Makes a connection between self and tunnel2 at the designated positions in each tunnel.
// Returns true if a connection was able to be made.
// Returns false otherwise.  It cannot make connection if positions are past bounds, a connection is already there,
// or if the two tunnels are of the same direction orientation.

- (BOOL)makeConnectionWithTunnel:(SkyTunnel *)tunnel2 atSelfPosition:(unsigned)selfPosition withTunnel2Position:(unsigned)tunnel2Position
{
    if (selfPosition >= self.length || tunnel2Position >= tunnel2.length) {
        NIMLOG_EVENT1(@"makeConnectionWithTunnel: connection position out of bounds");
        return false; // not able to connect past end of tunnels
    }
    if ([self.connectingTunnels objectAtIndex:selfPosition] != [NSNull null] ||
        [tunnel2.connectingTunnels objectAtIndex:tunnel2Position] != [NSNull null]) {
        NIMLOG_EVENT1(@"makeConnectionWithTunnel: Already a connection at designated location");
        return false;
    }
    if (self.direction == tunnel2.direction) {
        NIMLOG_EVENT1(@"makeConnectionWithTunnel: connecting tunnels are same orientation");
        return false;
    }
    
    // Make the connection
    [self.connectingTunnels replaceObjectAtIndex:selfPosition withObject:tunnel2];
    [self.connectingPositions replaceObjectAtIndex:selfPosition withObject:[NSNumber numberWithInt:tunnel2Position]];
    [tunnel2.connectingTunnels replaceObjectAtIndex:tunnel2Position withObject:self];
    [tunnel2.connectingPositions replaceObjectAtIndex:tunnel2Position withObject:[NSNumber numberWithInt:selfPosition]];
    
    // Set the position for tunnel2 accordingly
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    if (self.direction == HORIZONTAL_TUNNEL) {
        x = self.position.x + (selfPosition - (((float)self.length -1.0) / 2.0)) * MOVE_DISTANCE;
        y = self.position.y + ((((float)tunnel2.length - 1.0) / 2.0) - tunnel2Position) * MOVE_DISTANCE;
    }
    else {  // self.direction == VERTICAL_TUNNEL
        x = self.position.x + ((((float)tunnel2.length - 1.0) / 2.0) - tunnel2Position) * MOVE_DISTANCE;
        y = self.position.y + (selfPosition - (((float)self.length - 1.0) / 2.0)) * MOVE_DISTANCE;
    }
    tunnel2.position = CGPointMake(x,y);
    return true;
}

// Returns nil if it is not possible to move in the specified direction
// Returns the tunnel the person is in if they are able to move in that direction
// Usually the tunnel returned will be self, but if they moved to a connected tunnel, the connected tunnel is returned
- (SkyTunnel *)canMoveInDirection:(MOVE_DIRECTION)direction
                      forPosition:(unsigned long)position
                 checkConnections:(BOOL)checkConnections
{
    if (self.direction == VERTICAL_TUNNEL) {
        if (direction == UP_DIRECTION && position < self.length - 1) {
            return self; // Can move up except at top of tunnel
        }
        else if (direction == DOWN_DIRECTION && position > 0) {
            return self;  // Can move down except at end of tunnel
        }
    }
    else if (self.direction == HORIZONTAL_TUNNEL) {
        if (direction == LEFT_DIRECTION && position > 0) {
            return self;  // Can move left except at beginning of tunnel
        }
        else if (direction == RIGHT_DIRECTION && position < self.length - 1) {
            return self;  // Can move right except at end of tunnel
        }
    }
    
    // if cannot move in current tunnel, check if a connecting tunnel allows movement
    if (checkConnections && [self.connectingTunnels objectAtIndex:position] != [NSNull null]) {
        return [[self.connectingTunnels objectAtIndex:position]
                canMoveInDirection:direction
                forPosition:[[self.connectingPositions objectAtIndex:position] integerValue]
                checkConnections:false];
    }
    else {
        return nil; // No connecting tunnels
    }
    
}

@end
