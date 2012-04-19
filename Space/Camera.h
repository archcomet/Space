//
//  CameraController.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Entity.h"
#import "EntityLayer.h"
#import "BackgroundLayer.h"

@interface Camera : NSObject {

    CGPoint _position;
    Entity* _entity;

    EntityLayer* _entityLayer;
    BackgroundLayer* _backgroundLayer;
}

@property (readwrite, nonatomic) CGPoint position;

+(Camera*) camera;
-(void) trackEntity:(Entity*)entity;
-(void) step:(ccTime)dt;

@end
