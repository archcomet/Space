//
//  PlayerController.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "PlayerController.h"

@implementation PlayerController

@synthesize ship = _ship;

+(PlayerController*) playerControllerWithShip:(Ship*)ship
{
    PlayerController* c = [[[self alloc] init] autorelease];
    c.ship = ship;
    return c;
}

-(void) respondToTouchLocation:(CGPoint)touchLocation
{
    b2Vec2 touchTarget = b2Vec2(touchLocation.x / PTM_RATIO, touchLocation.y / PTM_RATIO);
    b2Vec2 touchVector = touchTarget;
    touchVector -= _ship.body->GetPosition();
    
    if (touchVector.Length() < touchThreshold) {
        [_ship changeSteeringBehavior:kSteeringBehaviorIdle];
    }
    else {
        touchVector.Normalize();
        [_ship changeSteeringBehavior:kSteeringBehaviorCruise withTargetPosition:touchVector];
    }
}

@end
