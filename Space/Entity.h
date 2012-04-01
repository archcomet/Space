//
//  Entity.h
//  Space
//
//  Created by Michael Good on 3/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#import "Common.h"
#import "EntityDef.h"
#import "MathHelper.h"

@interface Entity : NSObject {

    b2Body* _body;
    CCSprite* _sprite;
    EntityDef* _entityDef;
}

@property (readonly, nonatomic) b2Body* body;
@property (readonly, nonatomic) CCSprite* sprite;

-(id) initWithName:(NSString*)name position:(CGPoint)position rotation:(float)rotation;
-(void) createBody:(CGPoint)position rotation:(float)rotation;
-(void) step:(ccTime) dt;

-(void) beginContactWithEntity:(Entity*)entity manifold:(b2Manifold*)manifold;
-(void) endContactWithEntity:(Entity*)entity manifold:(b2Manifold*)manifold;  

@end
