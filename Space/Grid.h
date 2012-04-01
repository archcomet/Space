//
//  Grid.h
//  Space
//
//  Created by Michael Good on 2/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Line.h"

@interface Grid : CCNode {

    ccColor4B lineColor_;
    float lineSpacing_;
    float lineWidth_;
}

@property ccColor4B lineColor;
@property float lineSpacing;
@property float lineWidth;

@end
