//
//  InputLayer.mm
//  Space
//
//  Created by Michael Good on 3/15/12.
//  Copyright 2012 none. All rights reserved.
//

#import "InputLayer.h"
#import "GameScene.h"
#import "PlayerComponent.h"

@implementation InputLayer
@synthesize playerComponent = _playerComponent;

-(id) init
{
    if ((self = [super init])) {
		self.isTouchEnabled = YES;
    }
    return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_playerComponent) {
        for( UITouch *touch in touches )
        {
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            location = [[GameScene sharedGameScene] convertGLToWorldSpace:location];
            [_playerComponent respondToTouchLocation:location];
        }
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches )
    {
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        location = [[GameScene sharedGameScene] convertGLToWorldSpace:location];
        [_playerComponent respondToTouchLocation:location];
    }
}

@end
