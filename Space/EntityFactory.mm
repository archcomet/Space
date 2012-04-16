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

@interface EntityFactory (Hidden)
-(void) loadEntityDataWithEntityName:(NSString*)name;
-(void) addBodyComponentToEntity:(Entity*)entity;
-(void) addSpriteComponentToEntity:(Entity*)entity;
-(void) addVehicleComponentToEntity:(Entity*)entity;
-(void) addContrailComponentToEntity:(Entity*)entity;
@end

@implementation EntityFactory

#pragma mark EntityFactory - Memory Management

+(EntityFactory*) entityFactor
{
    return [[[self alloc] init] autorelease];
}

#pragma mark EntityFactory - Entity Creation

-(Entity*) loadEntityWithName:(NSString*)name
{
    [self loadEntityDataWithEntityName:name];    
    
    NSAssert(_entityData != nil, @"Failed to load entity data by name");
    
    Entity* entity = [Entity entity];    
    [self addBodyComponentToEntity:entity];
    [self addSpriteComponentToEntity:entity];
    [self addVehicleComponentToEntity:entity];
    [self addContrailComponentToEntity:entity];
    [entity bindComponents];
    
    return entity;
}

#pragma mark EntityFactory (Hidden) - Load

-(void) loadEntityDataWithEntityName:(NSString*)name
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
    NSDictionary* plistDictionary = 
    (NSDictionary*)[NSPropertyListSerialization propertyListFromData:plistXML 
                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                              format:&format errorDescription:&errorDesc];
    
    // Get the entity data
    _entityData = (NSDictionary*)[plistDictionary objectForKey:name];
}

#pragma mark EntityFactory (Hidden) - Add Components

-(void) addBodyComponentToEntity:(Entity*)entity
{
    NSDictionary* bodyData = [_entityData objectForKey:@"BodyComponent"];
    if (bodyData != nil)
    {
        b2BodyDef* bodyDef = new b2BodyDef();
        b2FixtureDef* fixtureDef = new b2FixtureDef();
        b2PolygonShape* shape = new b2PolygonShape();
        
        CGSize size = CGSizeFromString([bodyData objectForKey:@"size"]);
        shape->SetAsBox(size.width/PTM_RATIO/2, size.height/PTM_RATIO/2);
        
        bodyDef->type = b2_dynamicBody; 
        bodyDef->angularDamping = [[bodyData objectForKey:@"angularDampening"] floatValue];
        bodyDef->linearDamping = [[bodyData objectForKey:@"linearDampening"] floatValue];
        bodyDef->userData = entity;
    
        fixtureDef->shape = shape;
        fixtureDef->density = [[bodyData objectForKey:@"density"] floatValue];
        fixtureDef->friction = [[bodyData objectForKey:@"friction"] floatValue];
        fixtureDef->restitution = [[bodyData objectForKey:@"restitution"] floatValue];
        
        BodyComponent* component = [BodyComponent bodyComponentWithEntity:entity];
        component.bodyDef = bodyDef;
        component.fixtureDef = fixtureDef;
        [entity insertComponent:component atIndex:0];
    }
}

-(void) addSpriteComponentToEntity:(Entity *)entity
{
    NSDictionary* spriteData = [_entityData objectForKey:@"SpriteComponent"];
    if (spriteData != nil)
    {
        NSString* spriteFrameName = [spriteData objectForKey:@"spriteFrameName"];
        SpriteComponent* component = [SpriteComponent spriteComponentWithEntity:entity spriteFrameName:spriteFrameName];
        [entity addComponent:component];
    }
}

-(void) addVehicleComponentToEntity:(Entity *)entity
{
    NSDictionary* vehicleData = [_entityData objectForKey:@"VehicleComponent"];
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

-(void) addContrailComponentToEntity:(Entity *)entity
{
    NSDictionary* contrailData = [_entityData objectForKey:@"ContrailComponent"];
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

@end