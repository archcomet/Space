//
//  ContrailComponent.h
//  Space
//
//  Created by Michael Good on 4/12/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"
#import "Contrail.h"
#import "VehicleComponent.h"

@interface ContrailComponent : Component {
    Contrail* _contrail;
    BodyComponent* _bodyComponent;
    VehicleComponent* _vehicleComponent;
    
    float _minSpeed;
    float _maxDeltaX;
}

+(ContrailComponent*) contrailComponentWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef;
-(id) initWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef;

@end
