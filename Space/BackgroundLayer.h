//
//  BackgroundLayer.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BackgroundNode.h"
#import "Grid.h"

@interface BackgroundLayer : CCLayer {

    BackgroundNode* _starField;
    CCParticleSystemQuad* _starDust;
    Grid* _grid;
    
    CGPoint _position;
}

+(BackgroundLayer*) backgoundLayer;

@end
