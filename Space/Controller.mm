//
//  Controller.mm
//  Space
//
//  Created by Michael Good on 3/30/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Controller.h"

@implementation Controller

+(Controller*) controller
{
    return [[[self alloc] init] autorelease];
}

-(void) step:(ccTime)dt 
{ 
    // Override 
}

@end
