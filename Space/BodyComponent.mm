//
//  BodyComponent.mm
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "BodyComponent.h"
#import "GameScene.h"

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
        _bodyDef = nil;
        _fixtureDef = nil;
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

#pragma mark BodyComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    switch (state) {
        case kEntityStateNone:
            break;
            
        case kEntityStateSpawning:
            [self createBody];
            break;
            
        case kEntityStateDespawning:
            [self destroyBody];
            break;
            
        //case kEntityStateActive:
        default:
            b2Vec2 position = _body->GetPosition();
            _entity.position = ccp (position.x * PTM_RATIO, position.y * PTM_RATIO);
            _entity.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
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
    _body = [GameScene sharedGameScene].world->CreateBody(_bodyDef);
    _body->CreateFixture(_fixtureDef);
}

-(void) destroyBody
{
    if (_body != nil)
        [GameScene sharedGameScene].world->DestroyBody(_body);
}

@end
