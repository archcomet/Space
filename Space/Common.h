//
//  Common.h
//  Space
//
//  Created by Michael Good on 3/18/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#define touchThreshold 2.0

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 16

typedef enum {
    kEntityStateNone,
    kEntityStateSpawning,
    kEntityStateActive,
    kEntityStateDespawning
} EntityState;

typedef enum {
    kComponentTypeNone      = 0,
    kComponentTypeBody      = 0x01, //2^0
    kComponentTypeSprite    = 0x02, //2^1
    kComponentTypeVehicle   = 0x04, //2^2
    kComponentTypeContrail  = 0x08, //2^3
    kComponentTypeAIShip    = 0x10, //2^4
    kComponentTypePlayer    = 0x20  //2^5
} ComponentType;

typedef enum {
    kVehicleBehaviorIdle,
    kVehicleBehaviorCruise,
    kVehicleBehaviorWander,
    kVehicleBehaviorSeekTarget,
    kVehicleBehaviorPursueTarget,
    kVehicleBehaviorPursueTargetOffset,
    kVehicleBehaviorFleeTarget,
    kVehicleBehaviorEvadeTarget
} VehicleBehavior;