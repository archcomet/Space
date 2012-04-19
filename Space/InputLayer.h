//
//  InputLayer.h
//  Space
//
//  Created by Michael Good on 3/15/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ControllerComponent;
@class Entity;

@interface InputLayer : CCLayer {
    ControllerComponent* _controller;
    Entity* _entity;
}

-(void) setControlledEntity:(Entity*)entity;

@end
