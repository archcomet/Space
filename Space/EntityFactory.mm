//
//  EntityFactory.mm
//  Space
//
//  Created by Michael Good on 4/13/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "EntityFactory.h"
#import "BodyComponent.h"
#import "SpriteComponent.h"
#import "VehicleComponent.h"
#import "ContrailComponent.h"
#import "ControllerComponent.h"

@interface EntityFactory (Hidden)
-(void) loadEntityData;
-(void) addBodyComponentToEntity:(Entity*)entity withData:(NSDictionary*)data;
-(void) addSpriteComponentToEntity:(Entity*)entity withData:(NSDictionary*)data;
-(void) addVehicleComponentToEntity:(Entity*)entity withData:(NSDictionary*)data;
-(void) addContrailComponentToEntity:(Entity*)entity withData:(NSDictionary*)data;
-(void) addControllerComponentToEntity:(Entity*)entity;
@end

@implementation EntityFactory
@synthesize entities = _entities;

#pragma mark EntityFactory - Memory Management

+(EntityFactory*) sharedEntityFactory
{
    static EntityFactory* sharedEntityFactory;
    @synchronized(self) {
        if (!sharedEntityFactory) {
            sharedEntityFactory = [[self alloc] init];
        }
        return sharedEntityFactory;
    }
}

-(id)init
{
    if ((self = [super init])) {
        [self loadEntityData];
        _entities = [[CCArray array] retain];
    }
    return self;
}

-(void) dealloc
{
    [_entities removeAllObjects]; // Releases entities
    [_entities release];
    [_entityData release];
    [super dealloc];
}

#pragma mark EntityFactory - Entity Creation

-(Entity*) createEntityWithName:(NSString*)name category:(EntityCategory)category;
{
    NSDictionary* data = [_entityData objectForKey:name];
    NSAssert(data != nil, @"Failed to load entity data by name");
    
    Entity* entity = [Entity entity];    
    [self addBodyComponentToEntity:entity withData:data];
    [self addSpriteComponentToEntity:entity withData:data];
    [self addVehicleComponentToEntity:entity withData:data];
    [self addContrailComponentToEntity:entity withData:data];
    [self addControllerComponentToEntity:entity];
    
    [entity setCategory:category];
    [entity refreshComponents];

    [_entities addObject:entity]; // Retains entity
    return entity;
}

-(void) destroyEntity:(Entity*)entity
{
    [_entities fastRemoveObject:entity]; // Release entity
    if (entity.state != kEntityStateNone) {
        [entity destroyComponents];
    }
}

#pragma mark EntityFactory (Hidden) - Load

-(void) loadEntityData
{
    NSString* fileName = @"Entities";
    NSString* fullFileName = [NSString stringWithFormat:@"%@.plist", fileName];
    NSString* errorDesc = nil;
    NSString* plistPath;
    NSPropertyListFormat format;
    
    // Get the Path to the plist file
    NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    }    
    
    // Read the plist file
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    _entityData =  (NSDictionary*)[[NSPropertyListSerialization 
                                   propertyListFromData:plistXML 
                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                 format:&format errorDescription:&errorDesc] retain];
}

#pragma mark EntityFactory (Hidden) - Add Components

-(void) addBodyComponentToEntity:(Entity*)entity withData:(NSDictionary*)data
{
    NSDictionary* bodyData = [data objectForKey:@"BodyComponent"];
    if (bodyData != nil)
    {
        BodyComponent* component = [BodyComponent bodyComponentWithEntity:entity];
        
        b2BodyDef* bodyDef = component.bodyDef;
        b2FixtureDef* fixtureDef = component.fixtureDef;
        b2PolygonShape* shape = (b2PolygonShape*) fixtureDef->shape;
        
        CGSize size = CGSizeFromString([bodyData objectForKey:@"size"]);
        shape->SetAsBox(size.width/PTM_RATIO/2, size.height/PTM_RATIO/2);
        
        bodyDef->type = b2_dynamicBody; 
        bodyDef->angularDamping = [[bodyData objectForKey:@"angularDampening"] floatValue];
        bodyDef->linearDamping = [[bodyData objectForKey:@"linearDampening"] floatValue];
        bodyDef->userData = entity;
    
        fixtureDef->density = [[bodyData objectForKey:@"density"] floatValue];
        fixtureDef->friction = [[bodyData objectForKey:@"friction"] floatValue];
        fixtureDef->restitution = [[bodyData objectForKey:@"restitution"] floatValue];
        fixtureDef->userData = entity; 
        
        [entity insertComponent:component atIndex:0];
    }
}

-(void) addSpriteComponentToEntity:(Entity*)entity withData:(NSDictionary*)data
{
    NSDictionary* spriteData = [data objectForKey:@"SpriteComponent"];
    if (spriteData != nil)
    {
        NSString* spriteFrameName = [spriteData objectForKey:@"spriteFrameName"];
        SpriteComponent* component = [SpriteComponent spriteComponentWithEntity:entity spriteFrameName:spriteFrameName];
        [entity addComponent:component];
    }
}

-(void) addVehicleComponentToEntity:(Entity*)entity withData:(NSDictionary*)data
{
    NSDictionary* vehicleData = [data objectForKey:@"VehicleComponent"];
    if (vehicleData != nil)
    {
        VehicleDef def = VehicleDef();
        def.angularSlowingDistance = [[vehicleData objectForKey:@"angularSlowingDistance"] floatValue];
        def.linearSlowingDistance = [[vehicleData objectForKey:@"linearSlowingDistance"] floatValue];
        def.maxAngularVelocity = [[vehicleData objectForKey:@"maxAngularVelocity"] floatValue];
        def.maxLinearVelocity = [[vehicleData objectForKey:@"maxLinearVelocity"] floatValue];
        def.maxForce = [[vehicleData objectForKey:@"maxForce"] floatValue];
        def.maxTorque = [[vehicleData objectForKey:@"maxTorque"] floatValue];
        def.thrustVectorEfficiency = [[vehicleData objectForKey:@"thrustVectorEfficiency"] floatValue];

        VehicleComponent* component = [VehicleComponent vehicleComponentWithEntity:entity vehicleDef:def];
        [entity addComponent:component];
    }
}

-(void) addContrailComponentToEntity:(Entity*)entity withData:(NSDictionary*)data
{
    NSDictionary* contrailData = [data objectForKey:@"ContrailComponent"];
    if (contrailData != nil)
    {
        ContrailDef def = ContrailDef();
        def.offset = CGPointFromString([contrailData objectForKey:@"offset"]);
        def.width = [[contrailData objectForKey:@"width"] floatValue];
        def.baseColor.r = [[contrailData objectForKey:@"baseColorR"] intValue];
        def.baseColor.g = [[contrailData objectForKey:@"baseColorG"] intValue];
        def.baseColor.b = [[contrailData objectForKey:@"baseColorB"] intValue];
        
        ContrailComponent* component = [ContrailComponent contrailComponentWithEntity:entity contrailDef:def];
        [entity addComponent:component];
    }
}

-(void) addControllerComponentToEntity:(Entity*)entity
{
    ControllerComponent* controller = [ControllerComponent controllerComponentWithEntity:entity];
    [controller setPlayerControlled:false];
    [entity addComponent:controller];
}


@end