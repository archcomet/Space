//
//  CameraController.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Controller.h"
#import "Entity.h"

@interface CameraController : Controller {

    Entity* _trackedEntity;
}

@property (readwrite, nonatomic, assign) Entity* trackedEntity;

+(CameraController*) cameraControllerWithTrackedEntity:(Entity*)entity;

@end
