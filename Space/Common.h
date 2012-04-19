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

// EntityState is used for entity management. 
// Components respond to entity state on each step 
typedef enum {
    kEntityStateNone,       // Entity is not in the scene
    kEntityStateSpawning,   // Entity is being added to the scene
    kEntityStateActive,     // Entity is active in the scene
    kEntityStateDespawning  // Entity is being removed from the scene
} EntityState;

// EntityCategory is used the 'faction' of the entity.
// Hostile and friendly are in context of the player.
// Used in entity mask to determine hostility and collision
typedef enum {
    kEntityCategoryNone     = 0,
    kEntityCategoryPlayer   = 0x01, //2^0  
    kEntityCategoryFriendly = 0x02, //2^1
    kEntityCategoryHostile  = 0x04, //2^2
    kEntityCategoryScenery  = 0x08  //2^3
} EntityCategory;

// ComponentType is used to quickly determine if 
// an entity has a component of a given type.
typedef enum {
    kComponentTypeNone       = 0,
    kComponentTypeBody       = 0x01, //2^0
    kComponentTypeSprite     = 0x02, //2^1
    kComponentTypeVehicle    = 0x04, //2^2
    kComponentTypeContrail   = 0x08, //2^3
    kComponentTypeController = 0x10  //2^4
} ComponentType;


// VehicleBehavior is used to determine steering behavior
// by the vehicle component's finite state machine
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

// Entity masks determine relationship between EntityCategories. 
// Categories in the entity ask will be hostile and cause collision in the physics simulation.

#define ENTITY_FOE_MASK_NONE       kEntityCategoryNone
#define ENTITY_FOE_MASK_PLAYER     kEntityCategoryHostile | kEntityCategoryScenery
#define ENTITY_FOE_MASK_FRIENDLY   kEntityCategoryHostile | kEntityCategoryScenery
#define ENTITY_FOE_MASK_HOSTILE    kEntityCategoryPlayer | kEntityCategoryFriendly | kEntityCategoryScenery
#define ENTITY_FOE_MASK_SCENERY    0xFFFF //All

// Function to return the appropriate mask for a given category
inline unsigned short getEntityFoeMaskForCategory(EntityCategory entityCategory)
{
    switch (entityCategory) {
        case kEntityCategoryPlayer:
            return ENTITY_FOE_MASK_PLAYER;
        
        case kEntityCategoryFriendly:
            return ENTITY_FOE_MASK_FRIENDLY;
            
        case kEntityCategoryHostile:
            return ENTITY_FOE_MASK_HOSTILE;
        
        case kEntityCategoryScenery:
            return ENTITY_FOE_MASK_SCENERY;
            
        default:
            return ENTITY_FOE_MASK_NONE;
    }
}