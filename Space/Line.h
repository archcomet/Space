//
//  Line.h
//  Space
//
//  Created by Michael Good on 1/26/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Line : CCNode {
        
    ccColor4B lineColor_;
    float lineWidth_;
    
    CGPoint startPoint_;
    CGPoint endPoint_;
}

@property (readwrite, nonatomic) ccColor4B lineColor;
@property (readwrite, nonatomic) float lineWidth;

@property (readwrite, nonatomic) CGPoint startPoint;
@property (readwrite, nonatomic) CGPoint endPoint;

+(Line*) lineFrom:(CGPoint)p1 to:(CGPoint)p2;

@end
