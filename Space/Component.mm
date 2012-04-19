//
//  Component.mm
//  Space
//
//  Created by Michael Good on 4/11/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Component.h"

@implementation Component
@synthesize type = _type;
@synthesize entity = _entity;

-(id) initWithEntity:(Entity*)entity type:(ComponentType)type
{
    if ((self = [super init])) 
    {
        _type = type;
        _entity = entity;
    }
    return self;
}

-(void) refresh
{
    // Set pointers to other components in this method
}

-(void) destroy
{
    // Called when the component is destroyed
}

-(void) update:(ccTime)dt state:(EntityState)state
{
    // Gets called on each step
}

@end
