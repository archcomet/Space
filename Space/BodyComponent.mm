//
//  BodyComponent.mm
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "BodyComponent.h"
#import "GameScene.h"
#import "Callbacks.h"
#import "MathHelper.h"

@interface BodyComponent (Hidden)
-(void) createBody;
-(void) destroyBody;
@end

@implementation BodyComponent
@synthesize body = _body;
@synthesize bodyDef  = _bodyDef;
@synthesize fixtureDef = _fixtureDef;

#pragma mark BodyComponent - Memory Management

+(BodyComponent*) bodyComponentWithEntity:(Entity*)entity
{
    return [[[self alloc] initWithEntity:entity] autorelease];
}

-(id) initWithEntity:(Entity*)entity
{
    if ((self = [super initWithEntity:entity type:kComponentTypeBody]))
    {
        _body = nil;
        _bodyDef = new b2BodyDef();
        _fixtureDef = new b2FixtureDef();
        _fixtureDef->shape = new b2PolygonShape();
    }
    return self;
}

-(void) dealloc
{
    if (_fixtureDef) {
        delete _fixtureDef->shape;
        delete _fixtureDef;
    }
    
    if (_bodyDef) {
        delete _bodyDef;
    }
    
    [self destroyBody];
    [super dealloc];
}

#pragma mark BodyComponent - Destroy Component

- (void)destroy
{
    [self destroyBody];
}

#pragma mark BodyComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    switch (state) {
        case kEntityStateSpawning:
            [self createBody];
            break;
            
        case kEntityStateDespawning:
            [self destroyBody];
            break;
            
        default:
            break;
    }
}

#pragma mark BodyComponent (Hidden) - Body Create / Destroy

-(void) createBody
{
    [self destroyBody];
    
    CGPoint position = _entity.position;
    _bodyDef->position = b2Vec2(position.x/PTM_RATIO, position.y/PTM_RATIO);
    _bodyDef->angle = CC_DEGREES_TO_RADIANS(_entity.rotation);
    _bodyDef->userData = _entity;
    _fixtureDef->filter.categoryBits = _entity.category;
    _fixtureDef->filter.maskBits = _entity.foeMaskBits;
    _body = [GameScene sharedGameScene].world->CreateBody(_bodyDef);
    _body->CreateFixture(_fixtureDef);
}

-(void) destroyBody
{
    if (_body != nil)
        [GameScene sharedGameScene].world->DestroyBody(_body);
}

#pragma mark Entity - Queries

-(b2Body*) findNearestFoeWithinRange:(float)range
{
    QueryCallback callback = QueryCallback(_entity.category);
    b2Vec2 position = _body->GetPosition();
    b2AABB aabb = makeAABB(position, range/PTM_RATIO, range/PTM_RATIO);
    
    [GameScene sharedGameScene].world->QueryAABB(&callback, aabb);
    
    b2Body* nearestBody = NULL;
    float nearestDistance = FLT_MAX;
    
    vector<b2Body*>::iterator it;
    for (it = callback.foundBodies.begin(); it < callback.foundBodies.end(); it++)
    {
        b2Body* body = *it;
        b2Vec2 vec = position - body->GetPosition();
        float distance = vec.Length();
        
        if (distance < nearestDistance && distance < range) {
            nearestBody = body;
            nearestDistance = distance;
        }
    }
    
    return nearestBody;
}

@end
