//
//  BodyComponent.h
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"
#import "Box2D.h"

@interface BodyComponent : Component {
    
    b2Body* _body;
    b2BodyDef* _bodyDef;
    b2FixtureDef* _fixtureDef;
}

@property (readwrite, nonatomic) b2Body* body;
@property (readwrite, nonatomic) b2BodyDef* bodyDef;
@property (readwrite, nonatomic) b2FixtureDef* fixtureDef;

+(BodyComponent*) bodyComponentWithEntity:(Entity*)entity;
-(id) initWithEntity:(Entity*)entity;

-(b2Body*) findNearestFoeWithinRange:(float)range;

@end
