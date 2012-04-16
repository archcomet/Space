//
//  ContrailComponent.mm
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "ContrailComponent.h"
#import "GameScene.h"
#import "BodyComponent.h"
#import "VehicleComponent.h"

@implementation ContrailComponent

#pragma mark ContrailComponent - Memory Management

+(ContrailComponent*) contrailComponentWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef
{
    return [[[self alloc] initWithEntity:entity contrailDef:contrailDef] autorelease];
}

-(id) initWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef
{
    if ((self = [super initWithEntity:entity type:kComponentTypeContrail]))
    {
        _contrail = [[Contrail contrailWithEntity:entity contrailDef:contrailDef] retain];
        
        _minSpeed = contrailDef.minSpeed;
        _maxDeltaX = contrailDef.maxDeltaX;
    }
    return self;
}

-(void) dealloc
{
    [_contrail release];
    [super dealloc];
}

#pragma mark ContrailComponent - Bind Components

-(void) bind
{
    _vehicleComponent = (VehicleComponent*)[_entity getComponentByType:kComponentTypeVehicle];
    _bodyComponent = (BodyComponent*)[_entity getComponentByType:kComponentTypeBody];
}

#pragma mark ContrailComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    switch (state) {
        case kEntityStateNone:
            return;
        
        case kEntityStateSpawning:
            [[[GameScene sharedGameScene] entityLayer] addNode:_contrail z:-1];
            break;
        
        case kEntityStateDespawning:
            [[[GameScene sharedGameScene] entityLayer] removeNode:_contrail];
            break;
            
        //case kEntityStateActive:
        default:
            bool enabled = (_vehicleComponent.behavior != kVehicleBehaviorIdle);
            if (enabled) {
                b2Vec2 velocity = _bodyComponent.body->GetLinearVelocity();
                float speed = velocity.Length(); 
                enabled = (speed > _minSpeed);
                if (enabled && (_contrail.offset.x > 0 || _contrail.offset.y > 0)) {
                    float deltaX = ccpDot(ccp(velocity.x, velocity.y), _contrail.offset) / (speed * ccpLength(_contrail.offset));
                    enabled = (deltaX < _maxDeltaX);
                }
            }
            _contrail.enabled = enabled;
            break;
    }
}

@end
