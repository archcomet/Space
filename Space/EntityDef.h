//
//  EntityDef.h
//  Space
//
//  Created by Michael Good on 3/26/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EntityDef : NSObject {
    
    NSString* _spriteFrameName;
    float _density;
    float _friction;
    float _restitution;
    float _angularDampening;
    float _angularSlowingDistance;
    float _linearDampening;
    float _linearSlowingDistance;
    float _maxAngularVelocity;
    float _maxLinearVelocity;
    float _maxForce;
    float _maxTorque;
    float _tvcEfficiency;
    
    ccColor3B _contrailColor;
    float _contrailWidth;
}

@property (readonly, nonatomic) NSString* spriteFrameName;
@property (readonly, nonatomic) float density;
@property (readonly, nonatomic) float friction;
@property (readonly, nonatomic) float restituion;
@property (readonly, nonatomic) float angularDampening;
@property (readonly, nonatomic) float angularSlowingDistance;
@property (readonly, nonatomic) float linearDampening;
@property (readonly, nonatomic) float linearSlowingDistance;
@property (readonly, nonatomic) float maxAngularVelocity;
@property (readonly, nonatomic) float maxLinearVelocity;
@property (readonly, nonatomic) float maxForce;
@property (readonly, nonatomic) float maxTorque;
@property (readonly, nonatomic) float tvcEfficiency;

@property (readonly, nonatomic) ccColor3B contrailColor;
@property (readonly, nonatomic) float contrailWidth;

+(EntityDef*) entityDefWithName:(NSString*)name;
-(id) initWithName:(NSString*)name;
                    
@end
