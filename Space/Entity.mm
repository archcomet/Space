//
//  Entity.m
//  Space
//
//  Created by Michael Good on 3/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import "Entity.h"
#import "GameScene.h"

@implementation Entity

@synthesize body = _body;
@synthesize sprite = _sprite;

#pragma mark Entity - Alloc, Init, and Dealloc

-(id) initWithName:(NSString*)name position:(CGPoint)position rotation:(float)rotation
{
    if ((self = [super init])) {
        
        _entityDef = [[EntityDef entityDefWithName:name] retain];
        
        _sprite = [[CCSprite spriteWithSpriteFrameName:_entityDef.spriteFrameName] retain];
        _sprite.position = position;
        _sprite.rotation = rotation;
        _sprite.anchorPoint = ccp(0.5, 0.5);
        
        [self createBody:position rotation:rotation];
    }
    return self;
}

-(void) dealloc
{
    if (_body != nil) {
        b2World* world = [[GameScene sharedGameScene] world];
        world->DestroyBody(_body);
    }
    
    [_entityDef release];
    [_sprite release];
    [super dealloc];
}

#pragma mark Entity - Phsysics Body

-(void) createBody:(CGPoint)position rotation:(float)rotation
{
    // Create body def
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
    bodyDef.userData = self;
    
    // Create body
    b2World* world = [[GameScene sharedGameScene] world];
    _body = world->CreateBody(&bodyDef);
    _body->SetAngularDamping(_entityDef.angularDampening);
    _body->SetLinearDamping(_entityDef.linearDampening);
    
    // Create body shape
    b2PolygonShape entityShape;
    entityShape.SetAsBox(_sprite.contentSize.width/PTM_RATIO/2, 
                         _sprite.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition
    b2FixtureDef entityShapeDef;
    entityShapeDef.shape = &entityShape;
    entityShapeDef.density = _entityDef.density;
    entityShapeDef.friction = _entityDef.friction;
    entityShapeDef.restitution = _entityDef.restituion;
    
    _body->CreateFixture(&entityShapeDef); 
}

#pragma mark Entity - Step

-(void) step:(ccTime) dt
{
    if (_body != nil) {
        _sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
        _sprite.position = ccp(_body->GetPosition().x * PTM_RATIO, _body->GetPosition().y * PTM_RATIO);    
    }
}

-(void) beginContactWithEntity:(Entity*)entity manifold:(b2Manifold*)manifold
{
    
}


-(void) endContactWithEntity:(Entity*)entity manifold:(b2Manifold*)manifold
{
    
}

@end
