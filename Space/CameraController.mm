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

@synthesize trackedEntity = _trackedEntity;

+(CameraController*) cameraControllerWithTrackedEntity:(Entity*)entity
{
    CameraController* c = [[[self alloc] init] autorelease];
    c.trackedEntity = entity;
    return c;
}

-(void)step:(ccTime)dt
{
    [GameScene sharedGameScene].cameraPosition = _trackedEntity.sprite.position;
}

@end
