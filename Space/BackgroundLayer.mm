//
//  BackgroundLayer.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright 2012 none. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

+(BackgroundLayer*) backgoundLayer
{
    return [[[self alloc] init] autorelease];
}

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

@end

