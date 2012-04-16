//
//  CameraController.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "CameraController.h"
#import "GameScene.h"

@implementation CameraController
@synthesize position = _position;

#pragma mark CameraController - Memory Management

+(CameraController*) cameraController
{
    return [[[self alloc] init] autorelease];
}

-(id) init
{
    if ((self = [super init]))
    {
        _entity = nil;
        _position = ccp(0, 0);
        
        GameScene* scene = [GameScene sharedGameScene];
        _entityLayer = scene.entityLayer;
        _backgroundLayer = scene.backgroundLayer;
    }
    return self;
}

#pragma mark CameraController - Track Entity

-(void) trackEntity:(Entity*)entity
{
    _entity = entity;
}

#pragma mark CameraController - Step

-(void) step:(ccTime)dt
{
    if (_entity != nil && _entity.state != kEntityStateNone) {
        _position = _entity.position;
    }
    
    [_entityLayer updatePosition:_position];
    [_backgroundLayer updatePosition:_position];
}

@end
