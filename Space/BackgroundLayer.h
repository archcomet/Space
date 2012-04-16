//
//  BackgroundLayer.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Background.h"
#import "Grid.h"

@interface BackgroundLayer : CCLayer {

    Background* _starField;
    CCParticleSystemQuad* _starDust;
    Grid* _grid;
    
    CGPoint _position;
    CGSize _winSize;
}

+(BackgroundLayer*) backgoundLayer;
-(void) updatePosition:(CGPoint)position;

@end
