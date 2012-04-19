//
//  ControllerComponent.h
//  Space
//
//  Created by Michael Good on 4/18/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"

@class BodyComponent;
@class VehicleComponent;

@interface ControllerComponent : Component {    
    BodyComponent* _bodyComponent;
    VehicleComponent* _vehicleComponent;
    bool _playerControlled;
}

@property (readwrite, nonatomic) bool playerControlled;

+(ControllerComponent*) controllerComponentWithEntity:(Entity*)entity;
-(void) respondToTouchLocation:(CGPoint)touchLocation;
@end
