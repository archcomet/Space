//
//  Contrail.h
//  Space
//
//  Created by Michael Good on 3/19/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Entity.h"

struct ContrailDef {
    
    ContrailDef () 
    {
        offset = ccp(0, 0);
        baseColor = (ccColor3B) { 255, 255, 255 };
        segments = 25;
        fadeSpeed = 2;
        interval = 6;
        width = 3.0;
        minSpeed = 3.0;
        maxDeltaX = -0.55;
    }

    CGPoint offset;
    float width;
    float minSpeed;
    float maxDeltaX;
    int fadeSpeed;
    int interval;
    int segments;

    ccColor3B baseColor;
};

@interface Contrail : CCNode {

    ccVertex2F* _points;
    ccColor4B* _colors;
    int _segments;
    
    Entity* _entity;
    bool _enabled;
    int _steps;
    unsigned char _alpha;
    
    ccColor3B _baseColor;
    CGPoint _offset;
    float _width;
    int _fadeSpeed;
    int _interval;
}
@property (readwrite, nonatomic) ccColor3B color;
@property (readwrite, nonatomic) CGPoint offset;
@property (readwrite, nonatomic) bool enabled;
@property (readwrite, nonatomic) float width;
@property (readwrite, nonatomic) int fadeSpeed;
@property (readwrite, nonatomic) int interval;

+(Contrail*) contrailWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef;
-(id) initWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef;

@end
