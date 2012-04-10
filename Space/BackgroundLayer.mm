//
//  BackgroundLayer.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright 2012 none. All rights reserved.
//

#import "BackgroundLayer.h"
#import "GameScene.h"

@implementation BackgroundLayer

+(BackgroundLayer*) backgoundLayer
{
    return [[[self alloc] init] autorelease];
}

-(id) init
{
    if ((self = [super init]))
    {
        _starField = [[BackgroundNode backgroundNodeWithFile:@"Starfield3.png" position:ccp(0,0)] retain];
        _starDust = [[CCParticleSystemQuad particleWithFile:@"StarDust.plist"] retain];
        _grid = [[Grid node] retain];
        _grid.lineColor = ccc4(0, 225, 150, 150);
        _grid.lineSpacing = 120;
        _grid.lineWidth = 0.5;
        
        [self addChild:_starField z:0];
        [self addChild:_starDust z:1];
        [self addChild:_grid z: 2];
    }
    return self;
}

-(void) dealloc
{
    [self removeAllChildrenWithCleanup:true];
    [_starField release];
    [_starDust release];
    [_grid release];
    
    [super dealloc];
}

-(void) visit
{
    CGPoint prevPosition = _position;
    _position = [[GameScene sharedGameScene] cameraPosition];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint centerOfScreen = ccp(winSize.width * 0.5, winSize.height * 0.5);
    CGPoint newPosition = ccpSub(centerOfScreen, _position);
    CGPoint velocity = ccpSub(_position, prevPosition);
    
    [_grid setPosition:newPosition];
    [_starField setTexturePosition:ccpMult(newPosition, 0.07)];
    [_starDust setGravity:ccpMult(velocity, -10)];
    [super visit];
}

@end

