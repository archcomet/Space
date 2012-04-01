//
//  PolyLine.h
//  Space
//
//  Created by Michael Good on 1/27/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Line.h"

@interface PolyLine : Line {
 
    float fadeWidth_;    
}

@property (readwrite, nonatomic) float fadeWidth;

+(PolyLine*) lineFrom:(CGPoint)p1 to:(CGPoint)p2;

@end
