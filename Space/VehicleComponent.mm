//
//  VehicleComponent.mm
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "VehicleComponent.h"
#import "MathHelper.h"
#import "BodyComponent.h"

@interface VehicleComponent (Hidden)
-(void) rotateToTargetAngle:(float)targetAngle;
-(void) steerForVelocity:(b2Vec2)velocity;
-(void) steerForCruise;
-(void) steerForWander;
-(void) steerForSeek;
-(void) steerForFlee;
-(void) steerForPursit;
-(void) steerForOffsetPursit;
-(void) steerForEvasion;
-(void) steerToAvoidObstacle;
@end

@implementation VehicleComponent
@synthesize behavior = _vehicleBehavior;

#pragma mark VehicleComponent - Memory Management

+(VehicleComponent*) vehicleComponentWithEntity:(Entity*)entity vehicleDef:(VehicleDef)vehicleDef
{
    return [[[self alloc] initWithEntity:entity vehicleDef:vehicleDef] autorelease];
}

-(id) initWithEntity:(Entity*)entity vehicleDef:(VehicleDef)vehicleDef
{
    if ((self = [super initWithEntity:entity type:kComponentTypeVehicle]))
    {
        _vehicleBehavior = kVehicleBehaviorIdle;
        _targetBody = nil;
        _steeringSelector = nil;
        _maxAngularVelocity = vehicleDef.maxAngularVelocity;
        _maxLinearVelocity = vehicleDef.maxLinearVelocity;
        _maxTorque = vehicleDef.maxTorque;
        _maxForce = vehicleDef.maxForce;
        _angularSlowingDistance = vehicleDef.angularSlowingDistance;
        _linearSlowingDistance = vehicleDef.linearSlowingDistance;
        _thrustVectorEfficiency = vehicleDef.thrustVectorEfficiency;
    }
    return self;
}

#pragma mark VehicleComponent - Bind Components

-(void) bind
{
    _bodyComponent = (BodyComponent*)[_entity getComponentByType:kComponentTypeBody];
}

#pragma mark VehicleComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    switch (state) {
        case kEntityStateNone:
            return;
        
        case kEntityStateSpawning:
        case kEntityStateDespawning:
            _steeringSelector = nil;
            _targetBody = nil;
            _vehicleBehavior = kVehicleBehaviorIdle;
            break;

        //case kEntityStateActive:
        default:
            if (_steeringSelector != nil) {
                [self performSelector:_steeringSelector];
            }
            break;            
    }
}

#pragma mark VehicleComponent - Change Behavior

-(void) changeVehicleBehavior:(VehicleBehavior)vehicleBehavior
{
    _vehicleBehavior = vehicleBehavior;
    
    switch (_vehicleBehavior) {            
        case kVehicleBehaviorCruise:
            _steeringSelector = @selector(steerForCruise);
            break;
            
        case kVehicleBehaviorWander:
            _steeringSelector = @selector(steerForWander);
            break;
            
        case kVehicleBehaviorSeekTarget:
            _steeringSelector = @selector(steerForSeek);
            break;
            
        case kVehicleBehaviorPursueTarget:
            _steeringSelector = @selector(steerForPursit);
            break;
            
        case kVehicleBehaviorPursueTargetOffset:
            _steeringSelector = @selector(steerForOffsetPursit);
            break;
            
        case kVehicleBehaviorFleeTarget:
            _steeringSelector = @selector(steerForFlee);
            break;
            
        case kVehicleBehaviorEvadeTarget:
            _steeringSelector = @selector(steerForEvasion);
            break;
            
        default:
            _steeringSelector = nil;
            _targetBody = nil;
            break;
    }
}

-(void) changeVehicleBehavior:(VehicleBehavior)vehicleBehavior withTargetBody:(b2Body*)targetBody
{
    _targetBody = targetBody;
    [self changeVehicleBehavior:vehicleBehavior];
}

-(void) changeVehicleBehavior:(VehicleBehavior)vehicleBehavior withTargetPosition:(b2Vec2)targetPosition
{
    _targetBody = nil;
    _targetPosition = targetPosition;
    [self changeVehicleBehavior:vehicleBehavior];
}

#pragma mark VehicleComponent - Steering Calculations

-(void) rotateToTargetAngle:(float)targetAngle
{
    b2Body* vehicleBody = [_bodyComponent body];
    
    float bodyAngle = vehicleBody->GetAngle();
    float angularVelocity = vehicleBody->GetAngularVelocity();
    float targetOffsetAngle = targetAngle - bodyAngle;
    
    while (targetOffsetAngle >  PI) targetOffsetAngle -= PI*2;
    while (targetOffsetAngle < -PI) targetOffsetAngle += PI*2;
    
    float desiredVelocity;    
    if (fabsf(targetOffsetAngle) < _angularSlowingDistance) {
        desiredVelocity = _maxAngularVelocity * (targetOffsetAngle / _angularSlowingDistance);
    }
    else {
        desiredVelocity = (targetOffsetAngle > 0.0) ? _maxAngularVelocity : -_maxAngularVelocity;
    }
    
    float steering = desiredVelocity - angularVelocity;
    float torque = vehicleBody->GetInertia() * steering;
    torque = MIN(torque, _maxTorque);
    torque = MAX(torque, _maxTorque * -1);
    
    vehicleBody->ApplyTorque(torque);
}

-(void) steerForVelocity:(b2Vec2)velocity
{
    b2Body* vehicleBody = [_bodyComponent body];
    
    // Calculate steering force
    b2Vec2 steeringForce = velocity - vehicleBody->GetLinearVelocity();
    steeringForce *= vehicleBody->GetMass();    
    steeringForce = truncateVector(steeringForce, _maxForce);
    
    // Adjust for thrust vector efficiency
    if (_thrustVectorEfficiency < 1.0) {
        float thrustAlignment = 0.5 + (arcHorizontal(vehicleBody->GetTransform().R.col1, steeringForce) * 0.5);
        float thurstVariance = (1.0 - _thrustVectorEfficiency);
        steeringForce *= _thrustVectorEfficiency + thurstVariance * thrustAlignment;
    }
    
    vehicleBody->ApplyForce(steeringForce, vehicleBody->GetPosition()); 
    [self rotateToTargetAngle:angleFromVector(velocity)];  
}

-(void) steerForCruise;
{    
    // Calculate desired velocity
    b2Vec2 desiredVelocity = _targetPosition;
    desiredVelocity *= _maxLinearVelocity;
    [self steerForVelocity:desiredVelocity];
}

-(void) steerForWander
{
    
    
}

-(void) steerForSeek
{
    b2Body* vehicleBody = [_bodyComponent body];
    
    // Calculate desired max velocity to target
    b2Vec2 desiredVelocity = _targetPosition - vehicleBody->GetPosition();
    desiredVelocity.Normalize();
    desiredVelocity *= _maxLinearVelocity;
    
    [self steerForVelocity:desiredVelocity];
}

-(void) steerForPursit
{       
    b2Body* vehicleBody = [_bodyComponent body];
    
    // Get linear velocities 
    b2Vec2 targetVelocity = _targetBody->GetLinearVelocity();
    b2Vec2 vehicleVelocity = vehicleBody->GetLinearVelocity();
    
    // Calculate offset vector
    b2Vec2 targetPosition = _targetBody->GetPosition();
    b2Vec2 vehiclePosition = vehicleBody->GetPosition();
    b2Vec2 offsetVector = targetPosition - vehiclePosition;
    
    // Calculate prediction interval
    float relativeHeading = arcHorizontal(vehicleVelocity, targetVelocity);
    float relativePosition = arcHorizontal(offsetVector, targetVelocity);
    float headingModifier = 0.5 - fabsf(relativeHeading) * 0.5;
    float positionModifier = 0.5 - fabsf(relativePosition) * 0.5;
    float T = offsetVector.Length() / _maxLinearVelocity;
    T *= positionModifier + headingModifier;
    
    // Calculate predicted offset
    b2Vec2 predictedOffset = targetVelocity;
    predictedOffset *= T;
    
    // Calculate predicted target position
    _targetPosition = targetPosition;
    _targetPosition += predictedOffset;
    
    [self steerForSeek];
}

-(void) steerForOffsetPursit
{
    
    
}

-(void) steerForFlee
{
    
}

-(void) steerForEvasion
{
    
    
}

-(void) steerToAvoidObstacle
{
    
    
}


@end
