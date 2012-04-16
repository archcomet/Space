//
//  PlayerComponent.h
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"

@class BodyComponent;
@class VehicleComponent;

@interface PlayerComponent : Component {
    VehicleComponent* _vehicleComponent;
    BodyComponent* _bodyComponent;
}

+(PlayerComponent*) playerComponentWithEntity:(Entity*)entity;
-(void) respondToTouchLocation:(CGPoint)touchLocation;

@end
