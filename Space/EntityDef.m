//
//  EntityDef.m
//  Space
//
//  Created by Michael Good on 3/26/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "EntityDef.h"

@implementation EntityDef 

@synthesize spriteFrameName = _spriteFrameName;
@synthesize density = _density;
@synthesize friction = _friction;
@synthesize restituion = _restitution;
@synthesize angularDampening = _angularDampening;
@synthesize angularSlowingDistance = _angularSlowingDistance;
@synthesize linearDampening = _linearDampening;
@synthesize linearSlowingDistance = _linearSlowingDistance;
@synthesize maxAngularVelocity = _maxAngularVelocity;
@synthesize maxLinearVelocity = _maxLinearVelocity;
@synthesize maxForce = _maxForce;
@synthesize maxTorque = _maxTorque;
@synthesize tvcEfficiency = _tvcEfficiency;
@synthesize contrailColor = _contrailColor;
@synthesize contrailWidth = _contrailWidth;

+(EntityDef*) entityDefWithName:(NSString*)name
{
    return [[[self alloc] initWithName:name] autorelease];
}

-(id) initWithName:(NSString*)name
{
    if ((self = [super init]))
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
        NSDictionary* plistDictionary = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:plistXML 
                                                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                                  format:&format errorDescription:&errorDesc];

        NSDictionary* entityDictionary = (NSDictionary*)[plistDictionary objectForKey:name];
        
        _spriteFrameName = (NSString*)[entityDictionary objectForKey:@"SpriteFrameName"];
        
        _density = [[entityDictionary objectForKey:@"Density"] floatValue];
        _friction = [[entityDictionary objectForKey:@"Friction"] floatValue];
        _restitution = [[entityDictionary objectForKey:@"Restitution"] floatValue];
        
        _angularDampening = [[entityDictionary objectForKey:@"AngularDampening"] floatValue];
        _linearDampening = [[entityDictionary objectForKey:@"LinearDampening"] floatValue];
        _angularSlowingDistance = [[entityDictionary objectForKey:@"AngularSlowingDistance"] floatValue];
        _linearSlowingDistance =[[entityDictionary objectForKey:@"LinearSlowingDistance"] floatValue];
        _maxAngularVelocity = [[entityDictionary objectForKey:@"MaxAngularVelocity"] floatValue];
        _maxLinearVelocity = [[entityDictionary objectForKey:@"MaxLinearVelocity"] floatValue];
        _maxForce = [[entityDictionary objectForKey:@"MaxForce"] floatValue];
        _maxTorque = [[entityDictionary objectForKey:@"MaxTorque"] floatValue];
        _tvcEfficiency = [[entityDictionary objectForKey:@"TVCEfficiency"] floatValue];
        
        _contrailColor.r = [[entityDictionary objectForKey:@"ContrailColorR"] charValue];
        _contrailColor.g = [[entityDictionary objectForKey:@"ContrailColorG"] charValue];
        _contrailColor.b = [[entityDictionary objectForKey:@"ContrailColorB"] charValue];
        _contrailWidth = [[entityDictionary objectForKey:@"ContrailWidth"] floatValue];
    }
    return self;
}





@end
