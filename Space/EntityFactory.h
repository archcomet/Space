//
//  EntityFactory.h
//  Space
//
//  Created by Michael Good on 4/13/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface EntityFactory : NSObject {
    NSDictionary* _entityData;\
}

+(EntityFactory*) entityFactor;
-(Entity*) loadEntityWithName:(NSString*)name;

@end