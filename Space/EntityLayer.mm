//
//  EntityLayer.mm
//  Space
//
//  Created by Michael Good on 3/12/12.
//  Copyright 2012 none. All rights reserved.
//

#import "EntityLayer.h"
#import "GameScene.h"

@implementation EntityLayer

#pragma mark EntityLayer - Memory Management

+(EntityLayer*) entityLayerWithFile:(NSString*)file
{
    return [[[EntityLayer alloc] initWithFile:file] autorelease];
}

-(id)initWithFile:(NSString*)file
{
    if ((self = [super init]))
    {
        _spriteBatch = [[CCSpriteBatchNode batchNodeWithFile:file] retain];
        _winSize = [[CCDirector sharedDirector] winSize];
        
        [self addChild:_spriteBatch z:0];

    }
    return self;
}

-(void) dealloc
{
    [_spriteBatch release];
    [super dealloc];
}

#pragma mark EntityLayer - Node Management

-(void) addBatchSprite:(CCSprite*)sprite z:(int)z
{
    [_spriteBatch addChild:sprite z:z];
}

-(void) addNode:(CCNode*)node z:(int)z
{
    [self addChild:node z:z];
}

-(void) removeBatchSprite:(CCSprite*)sprite
{
    [_spriteBatch removeChild:sprite cleanup:true];
}

-(void) removeNode:(CCNode*)node
{
    [self removeChild:node cleanup:true];
}

#pragma mark Entitylayer - Update Position

-(void) updatePosition:(CGPoint)position
{
    CGPoint centerOfScreen = ccp(_winSize.width * 0.5, _winSize.height * 0.5);
    self.position = ccpSub(centerOfScreen, position);
}

@end
