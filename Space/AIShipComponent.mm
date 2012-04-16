//
//  AIShipComponent.mm
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "AIShipComponent.h"
#import "VehicleComponent.h"
#import "BodyComponent.h"
#import "GameScene.h"

@implementation AIShipComponent

#pragma mark AIShipComponent - Memory Management

+(AIShipComponent*) aiShipComponentWithEntity:(Entity*)entity
{
    return [[[self alloc] initWithEntity:entity type:kComponentTypeAIShip] autorelease];
}

#pragma mark AIShipComponent - Bind Components

-(void) bind
{
    _vehicle = (VehicleComponent*)[_entity getComponentByType:kComponentTypeVehicle];
}

#pragma mark AIShipComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    if (_vehicle.behavior == kVehicleBehaviorIdle)
    {
        Entity* entity = [[GameScene sharedGameScene] player];
        BodyComponent* bodyComponent = (BodyComponent*)[entity getComponentByType:kComponentTypeBody];
        b2Body* target =  bodyComponent.body;
        
        if (target != nil) {
            [_vehicle changeVehicleBehavior:kVehicleBehaviorPursueTarget withTargetBody:target];
        }
    }
}

@end
