//
//  EntityLayer.h
//  Space
//
//  Created by Michael Good on 3/12/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Entity.h"

@interface EntityLayer : CCLayer {
    
    CCSpriteBatchNode* _spriteBatch;
}

+(EntityLayer*) entityLayerWithFile:(NSString*)file;
-(id)initWithFile:(NSString*)file;

-(void)addEntity:(Entity *)entity;
-(void)addEntity:(Entity *)entity z:(NSInteger)z;
-(void)addEntity:(Entity *)entity z:(NSInteger)z tag:(NSInteger)tag;

-(void)removeAllEntitiesWithCleanup:(BOOL)cleanup;
-(void)removeEntity:(Entity *)entity cleanup:(BOOL)cleanup;
-(void)removeEntityByTag:(NSInteger)tag cleanup:(BOOL)cleanup;

@end
