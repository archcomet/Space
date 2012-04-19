//
//  ControllerComponent.mm
//  Space
//
//  Created by Michael Good on 4/18/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "ControllerComponent.h"
#import "BodyComponent.h"
#import "VehicleComponent.h"
#import "GameScene.h"

@implementation ControllerComponent
@synthesize playerControlled = _playerControlled;

#pragma mark ControllerComponent - Memory Management

+(ControllerComponent*) controllerComponentWithEntity:(Entity*)entity
{
    return [[[self alloc] initWithEntity:entity type:kComponentTypeController] autorelease];
}

#pragma mark ControllerComponent - Refresh Component

-(void) refresh
{
    _vehicleComponent = (VehicleComponent*)[_entity getComponentByType:kComponentTypeVehicle];
    _bodyComponent = (BodyComponent*)[_entity getComponentByType:kComponentTypeBody];
}

#pragma mark ControllerComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    if (state != kEntityStateActive) return;
    if (_playerControlled) return;
    
    if (_vehicleComponent && _vehicleComponent.behavior == kVehicleBehaviorIdle)
    {
        b2Body* target = [_bodyComponent findNearestFoeWithinRange:300];
        if (target) {
            [_vehicleComponent changeVehicleBehavior:kVehicleBehaviorPursueTarget withTargetBody:target];
        }
    }
}

-(void) respondToTouchLocation:(CGPoint)touchLocation
{
    if (_vehicleComponent == nil) return;
    
    b2Vec2 touchTarget = b2Vec2(touchLocation.x / PTM_RATIO, touchLocation.y / PTM_RATIO);
    b2Vec2 touchVector = touchTarget - [_bodyComponent body]->GetPosition();
    
    if (touchVector.Length() < touchThreshold) {
        [_vehicleComponent changeVehicleBehavior:kVehicleBehaviorIdle];
    }
    else {
        touchVector.Normalize();
        [_vehicleComponent changeVehicleBehavior:kVehicleBehaviorCruise withTargetPosition:touchVector];
    }
}

@end
