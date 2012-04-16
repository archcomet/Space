//
//  SpriteComponent.mm
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "SpriteComponent.h"
#import "GameScene.h"

@implementation SpriteComponent
@synthesize sprite = _sprite;

#pragma mark SpriteComponent - Memory Management

+(SpriteComponent*) spriteComponentWithEntity:(Entity*)entity spriteFrameName:(NSString*)spriteFrameName
{
    SpriteComponent* spriteComponent = [[[self alloc] initWithEntity:entity type:kComponentTypeSprite] autorelease];
    spriteComponent.sprite = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain];
    return spriteComponent;
}

-(void) dealloc
{
    [_sprite release];
    [super dealloc];
}

#pragma mark SpriteComponent - Update Component

-(void) update:(ccTime)dt state:(EntityState)state
{
    switch (state) {
        case kEntityStateNone:
            return;
            
        case kEntityStateSpawning:
            [[[GameScene sharedGameScene] entityLayer] addBatchSprite:_sprite z:0];
            break;
        
        case kEntityStateDespawning:
            [[[GameScene sharedGameScene] entityLayer] removeBatchSprite:_sprite];
            break;
            
        //case kEntityStateActive:
        default:
            break;
    }
    
    _sprite.position = _entity.position;
    _sprite.rotation = _entity.rotation;
}

@end