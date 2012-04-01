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
    kSteeringBehaviorIdle,
    kSteeringBehaviorCruise,
    kSteeringBehaviorWander,
    kSteeringBehaviorSeekTarget,
    kSteeringBehaviorPursueEntity,
    kSteeringBehaviorPursueEntityOffset,
    kSteeringBehaviorFleeTarget,
    kSteeringBehaviorEvadeEntity
} SteeringBehavior;

