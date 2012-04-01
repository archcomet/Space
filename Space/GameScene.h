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
#import "BackgroundNode.h"
#import "ContactListener.h"
#import "Controller.h"
#import "CameraController.h"
#import "PlayerController.h"
#import "Entity.h"
#import "EntityLayer.h"
#import "InputLayer.h"

@interface GameScene : CCScene {

    b2World* _world;
    ContactListener* _contactListener;
    
    CCParticleSystemQuad* _dust;
    BackgroundNode* _backgroundNode;
    EntityLayer* _entityLayer;
    InputLayer* _inputLayer;
    

    CCArray* _entities;
    CCArray* _controllers;
    
    CameraController* _cameraController;
    PlayerController* _playerController;
    
    CGPoint _scenePosition;
}

+(GameScene*) sharedGameScene;

@property (readonly, nonatomic) b2World* world;
@property (readonly, nonatomic) EntityLayer* entityLayer;
@property (readonly, nonatomic) PlayerController* playerController;

-(void) setScenePosition:(CGPoint)position;
-(void) addEntity:(Entity*)entity;
-(void) addController:(Controller*)controller;
-(CGPoint) convertGLToWorldSpace:(CGPoint)glLocation;

@end