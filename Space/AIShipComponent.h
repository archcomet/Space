//
//  AIShipComponent.h
//  Space
//
//  Created by Michael Good on 4/15/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"

@class VehicleComponent;

@interface AIShipComponent : Component {
    
    VehicleComponent* _vehicle;
}

+(AIShipComponent*) aiShipComponentWithEntity:(Entity*)entity;

@end
