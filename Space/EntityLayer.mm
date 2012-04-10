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

+(EntityLayer*) entityLayerWithFile:(NSString*)file
{
    return [[[EntityLayer alloc] initWithFile:file] autorelease];
}

-(id)initWithFile:(NSString*)file
{
    if ((self = [super init]))
    {
        _spriteBatch = [[CCSpriteBatchNode batchNodeWithFile:file] retain];
        [self addChild:_spriteBatch z:0];

    }
    return self;
}

-(void) dealloc
{
    [_spriteBatch release];
    [super dealloc];
}

-(void)addEntity:(Entity *)entity
{
    [_spriteBatch addChild:entity.sprite];
}

-(void)addEntity:(Entity *)entity z:(NSInteger)z
{
    [_spriteBatch addChild:entity.sprite z:z];
}

-(void)addEntity:(Entity *)entity z:(NSInteger)z tag:(NSInteger)tag
{
    [_spriteBatch addChild:entity.sprite z:z tag:tag];
}

-(void)removeAllEntitiesWithCleanup:(BOOL)cleanup
{
    [_spriteBatch removeAllChildrenWithCleanup:cleanup];
}

-(void)removeEntity:(Entity *)entity cleanup:(BOOL)cleanup
{
    [_spriteBatch removeChild:entity.sprite cleanup:cleanup];
}

-(void)removeEntityByTag:(NSInteger)tag cleanup:(BOOL)cleanup
{
    [_spriteBatch removeChildByTag:tag cleanup:cleanup];
}

-(void) visit
{
    CGPoint position = [[GameScene sharedGameScene] cameraPosition];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint centerOfScreen = ccp(winSize.width * 0.5, winSize.height * 0.5);
    self.position = ccpSub(centerOfScreen, position);
    
    [super visit];
}

@end
