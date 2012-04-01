//
//  Vehicle.mm
//  Space
//
//  Created by Michael Good on 3/26/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Vehicle.h"

@interface Vehicle (Hidden)
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

@implementation Vehicle

@synthesize steeringBehavior = _steeringBehavior;

#pragma mark Vehicle - Alloc, Init, and Dealloc

-(id) initWithName:(NSString *)name position:(CGPoint)position rotation:(float)rotation
{
    if ((self = [super initWithName:name position:position rotation:rotation]))
    {
        _maxAngularVelocity = _entityDef.maxAngularVelocity;
        _maxTorque = _entityDef.maxTorque;
        _angularSlowingDistance = _entityDef.angularSlowingDistance;
        
        _maxLinearVelocity = _entityDef.maxLinearVelocity;
        _maxForce = _entityDef.maxForce;
        _linearSlowingDistance = _entityDef.linearSlowingDistance;
        
        _tvcEfficiency = _entityDef.tvcEfficiency;

        _targetEntity = self;
        _targetPosition = b2Vec2(0, 0);
        
        [self changeSteeringBehavior:kSteeringBehaviorIdle];
    }
    return self;
}

#pragma mark Vehicle - Step

-(void) step:(ccTime)dt
{
    [super step:dt];
    
    if (_steeringBehaviorSelector != nil) {
        [self performSelector:_steeringBehaviorSelector];
    }
}

#pragma mark Vehicle - Input

-(void) changeSteeringBehavior:(SteeringBehavior)steeringBehavior
{
    _steeringBehavior = steeringBehavior;
    
    switch (_steeringBehavior) {
        case kSteeringBehaviorIdle:
            _steeringBehaviorSelector = nil;
            break;
            
        case kSteeringBehaviorCruise:
            _steeringBehaviorSelector = @selector(steerForCruise);
            break;
            
        case kSteeringBehaviorWander:
            _steeringBehaviorSelector = @selector(steerForWander);
            break;
            
        case kSteeringBehaviorSeekTarget:
            _steeringBehaviorSelector = @selector(steerForSeek);
            break;
            
        case kSteeringBehaviorPursueEntity:
            _steeringBehaviorSelector = @selector(steerForPursit);
            break;
            
        case kSteeringBehaviorPursueEntityOffset:
            _steeringBehaviorSelector = @selector(steerForOffsetPursit);
            break;
            
        case kSteeringBehaviorFleeTarget:
            _steeringBehaviorSelector = @selector(steerForFlee);
            break;
            
        case kSteeringBehaviorEvadeEntity:
            _steeringBehaviorSelector = @selector(steerForEvasion);
            break;
            
        default:
            break;
    }
}

-(void) changeSteeringBehavior:(SteeringBehavior)steeringBehavior withTargetPosition:(b2Vec2)targetPosition
{
    _targetPosition = targetPosition;
    [self changeSteeringBehavior:steeringBehavior];
}

-(void) changeSteeringBehavior:(SteeringBehavior)steeringBehavior withTargetEntity:(Entity*)entity
{
    _targetEntity = entity;
    [self changeSteeringBehavior:steeringBehavior];
}

#pragma mark Vehicle - Steering Behaviors

-(void) rotateToTargetAngle:(float)targetAngle
{
    float bodyAngle = _body->GetAngle();
    float angularVelocity = _body->GetAngularVelocity();
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
    float torque = _body->GetInertia() * steering;
    torque = MIN(torque, _maxTorque);
    torque = MAX(torque, _maxTorque * -1);
    
    _body->ApplyTorque(torque);
}

-(void) steerForVelocity:(b2Vec2)velocity
{
    // Calculate steering force
    b2Vec2 steeringForce = velocity - _body->GetLinearVelocity();
    steeringForce *= _body->GetMass();    
    steeringForce = truncateVector(steeringForce, _maxForce);
    
    // Adjust for thrust vector efficiency
    if (_tvcEfficiency < 1.0) {
        float thrustAlignment = 0.5 + (arcHorizontal(_body->GetTransform().R.col1, steeringForce) * 0.5);
        float thurstVariance = (1.0 - _tvcEfficiency);

        steeringForce *= _tvcEfficiency + thurstVariance * thrustAlignment;
    }
    
    // Apply force
    _body->ApplyForce(steeringForce, _body->GetPosition()); 
    
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
    // Calculate desired max velocity to target
    b2Vec2 desiredVelocity = _targetPosition - _body->GetPosition();
    desiredVelocity.Normalize();
    desiredVelocity *= _maxLinearVelocity;
    
    [self steerForVelocity:desiredVelocity];
}

-(void) steerForPursit
{       
    // Get linear velocities 
    b2Vec2 targetVelocity = _targetEntity.body->GetLinearVelocity();
    b2Vec2 velocity = _body->GetLinearVelocity();
    
    // Calculate offset vector
    b2Vec2 targetPosition = _targetEntity.body->GetPosition();
    b2Vec2 position = _body->GetPosition();
    b2Vec2 offsetVector = targetPosition - position;

    // Calculate prediction interval
    float relativeHeading = arcHorizontal(velocity, targetVelocity);
    float relativePosition = arcHorizontal(offsetVector, targetVelocity);
    float headingModifier = 0.5 - fabsf(relativeHeading) * 0.5;
    float positionModifier = 0.5 - fabsf(relativePosition) * 0.5;
    float T = offsetVector.Length() / _maxLinearVelocity;
    T *= positionModifier + headingModifier;
    
    // Calculate predicted offset
    b2Vec2 predictedOffset = targetVelocity;
    predictedOffset *= T;
    
    // Calculate predicted target position
    _targetPosition = _targetEntity.body->GetPosition();
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
