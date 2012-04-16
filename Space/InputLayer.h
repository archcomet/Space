//
//  InputLayer.h
//  Space
//
//  Created by Michael Good on 3/15/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class PlayerComponent;

@interface InputLayer : CCLayer {
    PlayerComponent* _playerComponent;
}

@property (readwrite, nonatomic, assign) PlayerComponent* playerComponent;

@end
