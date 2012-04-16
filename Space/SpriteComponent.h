//
//  SpriteComponent.h
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@interface SpriteComponent : Component {
    CCSprite* _sprite;
}

@property (readwrite, nonatomic, assign) CCSprite* sprite;

+(SpriteComponent*) spriteComponentWithEntity:(Entity*)entity spriteFrameName:(NSString*)spriteFrameName;

@end
