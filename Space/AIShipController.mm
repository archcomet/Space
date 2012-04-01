//
//  AIShipController.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "AIShipController.h"
#import "GameScene.h"

@implementation AIShipController

@synthesize ship = _ship;

+(AIShipController*) aiShipControllerWithShip:(Ship*)ship
{
    AIShipController* c = [[[self alloc] init] autorelease];
    c.ship = ship;    
    return c;
}

-(void) step:(ccTime)dt
{
    switch (_ship.steeringBehavior) {
        case kSteeringBehaviorIdle:
            [_ship changeSteeringBehavior:kSteeringBehaviorPursueEntity 
                         withTargetEntity:[[[GameScene sharedGameScene] playerController] ship]];
            break;
            
        default:
            break;
    }
    
}

@end
