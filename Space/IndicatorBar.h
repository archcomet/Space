//
//  IndicatorBar.h
//  Space
//
//  Created by Michael Good on 4/10/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kBarTypeHorizontal,
    kBarTypeVerticle
} BarType;

@interface IndicatorBar : CCNode {

    CGSize _size;
    BarType _type;

    float _value;
    float _minValue;
    float _maxValue;
    float _boarderWidth;
    float _dividerWidth;
    
    ccColor4B  _barColors[4];
    ccVertex2F _barVertices[4];    
    ccColor4B  _dividerColors[4];
    ccVertex2F _dividerVertices[4];
    ccColor4B  _backgroundColors[4];
    ccVertex2F _backgroundVertices[4];
    ccColor4B  _boarderColor;
    ccVertex2F _boarderVertices[5];
    
    bool _renderBar;
    bool _renderDivider;
    bool _renderBackground;
}

+(IndicatorBar*) indicatorBar;

@property (readwrite, nonatomic) CGSize size;
@property (readwrite, nonatomic) BarType type;
@property (readwrite, nonatomic) float value;
@property (readwrite, nonatomic) float minValue;
@property (readwrite, nonatomic) float maxValue;
@property (readwrite, nonatomic) float boarderWidth;
@property (readwrite, nonatomic) float dividerWidth;
@property (readwrite, nonatomic) ccColor4B barStartColor;
@property (readwrite, nonatomic) ccColor4B barEndColor;
@property (readwrite, nonatomic) ccColor4B dividerStartColor;
@property (readwrite, nonatomic) ccColor4B dividerEndColor;
@property (readwrite, nonatomic) ccColor4B backgroundStartColor;
@property (readwrite, nonatomic) ccColor4B backgroundEndColor;
@property (readwrite, nonatomic) ccColor4B boarderColor;

@end