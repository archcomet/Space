//
//  Entity.mm
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Entity.h"
#import "GameScene.h"
#import "Component.h"

@implementation Entity
@synthesize state = _state;
@synthesize position = _position;
@synthesize rotation = _rotation;

#pragma mark Entity - Memmory Management

+(Entity*) entity
{
    return [[[self alloc] init] autorelease];
}

-(id) init
{
    if ((self = [super init])) {
        _state = kEntityStateNone;
        _components = [[CCArray array] retain];
        _componentTypes = kComponentTypeNone;
    }
    return self;
}

-(void) dealloc
{
    if (_components) {
        [_components removeAllObjects];
        [_components release];
    }
    [super dealloc];
}

#pragma mark Entity - Component Management

-(Component*) getComponentByType:(ComponentType)type
{
    if ([self hasComponenType:type])
    {
        Component* c;
        CCARRAY_FOREACH(_components, c) {
            if (c.type == type)
                return c;
        }
    }
    return nil;
}

-(bool) hasComponenType:(ComponentType)type
{
    return ((_componentTypes & type) == type);
}

-(void) addComponent:(Component*)component
{
    NSAssert(![self hasComponenType:component.type], @"Failed to add component. Entity has a component of same type already!");
    
    [_components addObject:component];
    _componentTypes |= component.type;
}

-(void) insertComponent:(Component*)component atIndex:(int)index
{
    NSAssert(![self hasComponenType:component.type], @"Failed to insert component. Entity has a component of same type already!");

    [_components insertObject:component atIndex:index];
    _componentTypes |= component.type;
}

-(void) removeComponent:(Component*)component
{
    [_components removeObject:component];
    _componentTypes &= ~component.type;
}

-(void) bindComponents
{
    Component* c;
    CCARRAY_FOREACH(_components, c) {
        [c bind];
    }
}

#pragma mark Entity - Life Cycle

-(void) spawnEntityWithPosition:(CGPoint)position rotation:(float)rotation
{
    _position = position;
    _rotation = rotation;
    _state = kEntityStateSpawning;
}

-(void) despawnEntity
{
    _state = kEntityStateDespawning;
}

#pragma mark Entity - Step

-(void) step:(ccTime)dt
{
    if (_state == kEntityStateNone) return;
    
    if (_components) {
        Component* c;
        CCARRAY_FOREACH(_components, c) {
            [c update:dt state:_state];
        }
    }
    
    switch (_state) {
        case kEntityStateSpawning:
            _state = kEntityStateActive;
            break;
            
        case kEntityStateDespawning:
            _state = kEntityStateNone;
            break;
            
        default:
            break;
    }
}

@end
