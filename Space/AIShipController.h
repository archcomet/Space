//
//  AIShipController.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Controller.h"
#import "Ship.h"

@interface AIShipController : Controller {
    Ship* _ship;
}

@property (readwrite, nonatomic, assign) Ship* ship;

+(AIShipController*) aiShipControllerWithShip:(Ship*)ship;

@end
