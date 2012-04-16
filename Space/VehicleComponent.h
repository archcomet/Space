//
//  VehicleComponent.h
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"
#import "Box2D.h"

@class BodyComponent;

struct VehicleDef {
    VehicleDef() { }
    float maxAngularVelocity;
    float maxLinearVelocity;
    float maxTorque;
    float maxForce;
    float angularSlowingDistance;
    float linearSlowingDistance;
    float thrustVectorEfficiency;
};

@interface VehicleComponent : Component {
    
    BodyComponent* _bodyComponent;
    VehicleBehavior _vehicleBehavior;
    b2Body* _targetBody;
    b2Vec2 _targetPosition;

    float _maxAngularVelocity;
    float _maxLinearVelocity;
    float _maxTorque;
    float _maxForce;
    float _angularSlowingDistance;
    float _linearSlowingDistance;
    float _thrustVectorEfficiency;
    
    SEL _steeringSelector;
}

@property (readonly, nonatomic) VehicleBehavior behavior;

+(VehicleComponent*) vehicleComponentWithEntity:(Entity*)entity vehicleDef:(VehicleDef)vehicleDef;
-(id) initWithEntity:(Entity*)entity vehicleDef:(VehicleDef)vehicleDef;

-(void) changeVehicleBehavior:(VehicleBehavior)vehicleBehavior;
-(void) changeVehicleBehavior:(VehicleBehavior)vehicleBehavior withTargetBody:(b2Body*)targetBody;
-(void) changeVehicleBehavior:(VehicleBehavior)vehicleBehavior withTargetPosition:(b2Vec2)targetPosition;

@end
