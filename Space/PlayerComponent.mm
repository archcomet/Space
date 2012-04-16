//
//  PlayerComponent.mm
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "PlayerComponent.h"
#import "BodyComponent.h"
#import "VehicleComponent.h"

@implementation PlayerComponent

#pragma mark PlayerComponent - Memory Management

+(PlayerComponent*) playerComponentWithEntity:(Entity*)entity
{
    return [[[self alloc] initWithEntity:entity type:kComponentTypePlayer] autorelease];
}

#pragma mark PlayerComponent - Bind Components

-(void) bind
{
    _vehicleComponent = (VehicleComponent*)[_entity getComponentByType:kComponentTypeVehicle];
    _bodyComponent = (BodyComponent*)[_entity getComponentByType:kComponentTypeBody];
}

#pragma mark PlayerComponent - Inputs

-(void) respondToTouchLocation:(CGPoint)touchLocation
{
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
