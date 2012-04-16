//
//  GameScene.h
//  Space
//
//  Created by Michael Good on 2/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Entity.h"
#import "ContactListener.h"
#import "CameraController.h"
#import "BackgroundLayer.h"
#import "EntityLayer.h"
#import "InputLayer.h"
#import "EntityFactory.h"

@interface GameScene : CCScene {

    b2World* _world;
    ContactListener* _contactListener;
    
    BackgroundLayer* _backgroundLayer;
    EntityLayer* _entityLayer;
    InputLayer* _inputLayer;

    CameraController* _cameraController;
    
    EntityFactory* _entityFactory;
    CCArray* _entities;
    Entity* _player;
}

+(GameScene*) sharedGameScene;

@property (readonly, nonatomic) b2World* world;
@property (readonly, nonatomic) Entity* player;
@property (readonly, nonatomic) EntityLayer* entityLayer;
@property (readonly, nonatomic) BackgroundLayer* backgroundLayer;
@property (readonly, nonatomic) CameraController* cameraController;

-(CGPoint) convertGLToWorldSpace:(CGPoint)glLocation;

@end