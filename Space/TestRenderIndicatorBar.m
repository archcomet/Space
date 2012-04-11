//
//  TestRenderIndicatorBar.m
//  Space
//
//  Created by Michael Good on 4/10/12.
//  Copyright 2012 none. All rights reserved.
//

#import "TestRenderIndicatorBar.h"
#import "IndicatorBar.h"

@implementation TestRenderIndicatorBar

-(id) init
{
    if ((self = [super init]))
    {
        IndicatorBar* bar;
        
        // small 50%
        bar = [IndicatorBar indicatorBar];
        bar.size = CGSizeMake(100, 5);
        bar.type = kBarTypeHorizontal;
        bar.barStartColor = ccc4(0, 0, 150, 255);
        bar.barEndColor = ccc4(0, 0, 255, 255);
        bar.dividerStartColor = ccc4(0, 0, 255, 255);
        bar.dividerEndColor = ccc4(200, 200, 255, 255);
        bar.backgroundStartColor = ccc4(0, 0, 0, 255);
        bar.backgroundEndColor = ccc4(0, 0, 0, 255);
        bar.boarderWidth = 1;
        bar.boarderColor = ccc4(255, 255, 255, 255);
        bar.dividerWidth = 20;
        bar.minValue = 0.0;
        bar.maxValue = 100;
        bar.value = 50;
        bar.position = ccp(20, 295);
        bar.anchorPoint = ccp(0, 0);
        bar.visible = true;
        [self addChild:bar z:100];
        _shieldBar = bar;
        
        // small 100%
        bar = [IndicatorBar indicatorBar];
        bar.size = CGSizeMake(100, 5);
        bar.type = kBarTypeHorizontal;
        bar.barStartColor = ccc4(0, 150, 0, 255);
        bar.barEndColor = ccc4(0, 255, 0, 255);
        bar.dividerStartColor = ccc4(0, 255, 0, 255);
        bar.dividerEndColor = ccc4(200, 200, 0, 255);
        bar.backgroundStartColor = ccc4(0, 0, 0, 255);
        bar.backgroundEndColor = ccc4(0, 0, 0, 255);
        bar.boarderWidth = 1;
        bar.boarderColor = ccc4(255, 255, 255, 255);
        bar.dividerWidth = 20;
        bar.minValue = 0.0;
        bar.maxValue = 100;
        bar.value = 100;
        bar.position = ccp(20, 290);
        bar.anchorPoint = ccp(0, 0);
        bar.visible = true;
        [self addChild:bar z:100];
        _armorBar = bar;
        
        // large 
        bar = [IndicatorBar indicatorBar];
        bar.size = CGSizeMake(20, 250);
        bar.type = kBarTypeVerticle;
        bar.barStartColor = ccc4(0, 0, 100, 100);
        bar.barEndColor = ccc4(0, 0, 255, 100);
        bar.dividerStartColor = ccc4(0, 0, 255, 100);
        bar.dividerEndColor = ccc4(200, 200, 0, 100);
        bar.backgroundStartColor = ccc4(0, 0, 0, 100);
        bar.backgroundEndColor = ccc4(0, 0, 0, 100);
        bar.boarderWidth = 1;
        bar.boarderColor = ccc4(255, 255, 255, 100);
        bar.dividerWidth = 33;
        bar.minValue = 0.0;
        bar.maxValue = 100;
        bar.value = 90;
        bar.position = ccp(430, 20);
        bar.anchorPoint = ccp(0, 0);
        bar.visible = true;
        [self addChild:bar z:100];
        _largeBar = bar;
        
        [self schedule: @selector(step:)];
    }
    return self;
}

-(void) step:(ccTime)dt
{
    if (_largeBarUp) {
        _largeBar.value += 1.0;
        if (_largeBar.value == _largeBar.maxValue) _largeBarUp = false;
    }
    else {
        _largeBar.value -= 2.0;
        if (_largeBar.value == _largeBar.minValue) _largeBarUp = true;
    }
    
    
    if (_comboUp) {
        
        if (_armorBar.value == _armorBar.maxValue) {
            _shieldBar.value += 1.0;
            if (_shieldBar.value == _shieldBar.maxValue) _comboUp = false;
        }
        else {
            _armorBar.value += 1.0;
        }
    }
    else {
        
        if (_shieldBar.value == _shieldBar.minValue) {
            _armorBar.value -= 1.0;
            if (_armorBar.value == _armorBar.minValue) _comboUp = true;
        }
        else {
            _shieldBar.value -= 1.0;
        }
    }
}

@end
