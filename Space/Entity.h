//
//  Entity.h
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#import "Common.h"

@class Component;

@interface Entity : NSObject {
    
    // Public members
    EntityState _state;
    CGPoint _position;
    float _rotation;
    
    // Private members
    CCArray* _components;
    int _componentTypes;
}

@property (readwrite, nonatomic) EntityState state;
@property (readwrite, nonatomic) CGPoint position;
@property (readwrite, nonatomic) float rotation;

+(Entity*) entity;
-(Component*) getComponentByType:(ComponentType)type;
-(bool) hasComponenType:(ComponentType)type;
-(void) addComponent:(Component*)component;
-(void) insertComponent:(Component*)component atIndex:(int)index;
-(void) removeComponent:(Component*)component;
-(void) bindComponents;
-(void) spawnEntityWithPosition:(CGPoint)position rotation:(float)rotation;
-(void) despawnEntity;
-(void) step:(ccTime)dt;

@end