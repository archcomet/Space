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
    CGSize _winSize;
}

+(EntityLayer*) entityLayerWithFile:(NSString*)file;
-(id)initWithFile:(NSString*)file;

-(void) addBatchSprite:(CCSprite*)sprite z:(int)z;
-(void) addNode:(CCNode*)node z:(int)z;
-(void) removeBatchSprite:(CCSprite*)sprite;
-(void) removeNode:(CCNode*)node;
-(void) updatePosition:(CGPoint)position;

@end
