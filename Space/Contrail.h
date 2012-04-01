//
//  Contrail.h
//  Space
//
//  Created by Michael Good on 3/19/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Contrail : CCNode {

    ccVertex2F* _points;
    ccColor4B* _colors;
    ccColor3B _baseColor;
    float _width;
    int _segments;
    int _minSpeed;
    int _fadeSpeed;
    int _interval;  
    int _steps;
    unsigned char _alpha;
}

@property (readwrite, nonatomic) ccColor3B color;
@property (readwrite, nonatomic) float width;
@property (readwrite, nonatomic) int minSpeed;
@property (readwrite, nonatomic) int fadeSpeed;
@property (readwrite, nonatomic) int interval;

+(Contrail*) contrailWithSegments:(int)segments position:(CGPoint)position;
-(id) initWithSegments:(int)segments position:(CGPoint)position;
-(void) updateWithPosition:(CGPoint)position speed:(int)speed;

@end
