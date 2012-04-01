//
//  Ship.h
//  Space
//
//  Created by Michael Good on 3/26/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Vehicle.h"
#import "Contrail.h"

@interface Ship : Vehicle {
    
    Contrail* _contrail;
}

+(Ship*) shipWithName:(NSString*)name position:(CGPoint)position rotation:(float)rotation;

@end
