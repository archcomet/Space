//
//  TestRenderIndicatorBar.h
//  Space
//
//  Created by Michael Good on 4/10/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IndicatorBar.h"

@interface TestRenderIndicatorBar : CCLayer {
 
    IndicatorBar* _largeBar;
    bool _largeBarUp;
    
    IndicatorBar* _shieldBar;
    IndicatorBar* _armorBar;
    bool _comboUp;
}

@end
