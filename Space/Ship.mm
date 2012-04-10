//
//  Ship.mm
//  Space
//
//  Created by Michael Good on 3/26/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Ship.h"
#import "GameScene.h"

@implementation Ship

#pragma mark Ship - Alloc, Init, and Dealloc

+(Ship*) shipWithName:(NSString*)name position:(CGPoint)position rotation:(float)rotation
{
    return [[[self alloc] initWithName:name position:position rotation:rotation] autorelease];
}

-(id) initWithName:(NSString *)name position:(CGPoint)position rotation:(float)rotation
{
    if ((self = [super initWithName:name position:position rotation:rotation])) {
        
        _contrail = [[ContrailNode contrailWithVehicle:self] retain];
        _contrail.color = _entityDef.contrailColor;
        _contrail.width = _entityDef.contrailWidth;
        _contrail.offset = ccp(-_sprite.contentSize.width * 0.4, 0.0);
    }
    return self;
}

-(void) dealloc
{
    [_contrail release];
    [super dealloc];
}


@end
