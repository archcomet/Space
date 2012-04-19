//
//  InputLayer.mm
//  Space
//
//  Created by Michael Good on 3/15/12.
//  Copyright 2012 none. All rights reserved.
//

#import "InputLayer.h"
#import "GameScene.h"
#import "ControllerComponent.h"
#import "Entity.h"

@implementation InputLayer

-(id) init
{
    if ((self = [super init])) {
		self.isTouchEnabled = YES;
    }
    return self;
}

-(void) setControlledEntity:(Entity*)entity 
{
    _controller = (ControllerComponent*)[entity getComponentByType:kComponentTypeController];
    [_controller setPlayerControlled:true];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_controller) {
        for( UITouch *touch in touches )
        {
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            location = [[GameScene sharedGameScene] convertGLToWorldSpace:location];
            [_controller respondToTouchLocation:location];
        }
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_controller) {
        for( UITouch *touch in touches )
        {
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            location = [[GameScene sharedGameScene] convertGLToWorldSpace:location];
            [_controller respondToTouchLocation:location];
        }
    }
}

@end
