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
    
    NSDictionary* _entityData;
    CCArray* _entities;
}

@property (readonly, nonatomic) CCArray* entities;

+(EntityFactory*) sharedEntityFactory;

-(Entity*) createEntityWithName:(NSString*)name category:(EntityCategory)category;
-(void) destroyEntity:(Entity*)entity;

@end