//
//  Component.h
//  Space
//
//  Created by Michael Good on 4/11/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "cocos2d.h"
#import "Entity.h"

@class Entity;

@interface Component : NSObject {
    ComponentType _type;
    Entity* _entity;
}

@property  (readwrite, nonatomic) ComponentType type;
@property  (readwrite, nonatomic, assign) Entity* entity;

-(id) initWithEntity:(Entity*)entity type:(ComponentType)type;
-(void) bind;
-(void) update:(ccTime)dt state:(EntityState)state;

@end
