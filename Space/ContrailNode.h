//
//  ContrailNode.h
//  Space
//
//  Created by Michael Good on 3/19/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Vehicle.h"

@interface ContrailNode : CCNode {

    Vehicle* _vehicle;
    ccVertex2F* _points;
    ccColor4B* _colors;
    ccColor3B _baseColor;
    CGPoint _offset;
    unsigned char _alpha;
    bool _enabled;
    float _width;
    float _minSpeed;
    float _maxDeltaX;
    int _segments;
    int _fadeSpeed;
    int _interval;  
    int _steps;
}
@property (readwrite, nonatomic) ccColor3B color;
@property (readwrite, nonatomic) CGPoint offset;
@property (readwrite, nonatomic) bool enabled;
@property (readwrite, nonatomic) float width;
@property (readwrite, nonatomic) float minSpeed;
@property (readwrite, nonatomic) float maxDeltaX;
@property (readwrite, nonatomic) int fadeSpeed;
@property (readwrite, nonatomic) int interval;

+(ContrailNode*) contrailWithVehicle:(Vehicle*)vehicle;
-(id) initWithVehicle:(Vehicle*)vehicle;

@end
