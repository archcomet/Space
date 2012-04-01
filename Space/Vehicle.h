//
//  Vehicle.h
//  Space
//
//  Created by Michael Good on 3/26/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Entity.h"

@interface Vehicle : Entity {
    
    SEL _steeringBehaviorSelector;
    SteeringBehavior _steeringBehavior;
    b2Vec2 _targetPosition;
    Entity* _targetEntity;

    float _maxAngularVelocity;
    float _maxTorque;
    float _angularSlowingDistance;
    float _maxLinearVelocity;
    float _maxForce;
    float _linearSlowingDistance;
    float _tvcEfficiency;
}

@property (readonly, nonatomic) SteeringBehavior steeringBehavior;

-(void) changeSteeringBehavior:(SteeringBehavior)steeringBehavior;
-(void) changeSteeringBehavior:(SteeringBehavior)steeringBehavior withTargetPosition:(b2Vec2)targetPosition;
-(void) changeSteeringBehavior:(SteeringBehavior)steeringBehavior withTargetEntity:(Entity*)entity;

@end