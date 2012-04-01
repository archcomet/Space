//
//  PlayerController.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Controller.h"
#import "Ship.h"

@interface PlayerController : Controller {
    Ship* _ship;
}

@property (readwrite, nonatomic, assign) Ship* ship;

+(PlayerController*) playerControllerWithShip:(Ship*)ship;

-(void) respondToTouchLocation:(CGPoint)touchLocation;

@end
