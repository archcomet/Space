//
//  Controller.h
//  Space
//
//  Created by Michael Good on 3/30/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Controller : NSObject

+(Controller*) controller;
-(void) step:(ccTime)dt;

@end
