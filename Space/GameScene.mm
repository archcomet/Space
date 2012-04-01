//
//  GameScene.mm
//  Space
//
//  Created by Michael Good on 2/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import "GameScene.h"
#import "AIShipController.h"
#import "Ship.h"
#import "Grid.h"
#import "BackgroundNode.h"

@interface GameScene (Hidden)
-(void) startScene;
-(void) createWorld;
-(void) createSpriteFrameCache;
-(void) createLayers;
-(void) createEntitiesAndControllers;
@end

@implementation GameScene

@synthesize world = _world;
@synthesize entityLayer = _entityLayer;
@synthesize playerController = _playerController;

#pragma mark GameScene - Alloc, Init, and Dealloc

+(GameScene*) sharedGameScene
{
    static GameScene *sharedGameScene;
    
    @synchronized(self)
    {
        if (!sharedGameScene)
        {
            sharedGameScene = [[self alloc] init];
            [sharedGameScene startScene];
        }
        
        return sharedGameScene;
    }
}

-(void) startScene
{    
    [self createWorld];
    [self createSpriteFrameCache];
    [self createLayers];
    [self createEntitiesAndControllers];    
    
    [self schedule: @selector(step:)];
}

-(void) createWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
    
    _contactListener = new ContactListener();
    _world->SetContactListener(_contactListener);
}

-(void) createSpriteFrameCache
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SpaceShips.plist"];
}

-(void) createLayers
{
    _entityLayer = [[EntityLayer entityLayerWithFile:@"SpaceShips.png"] retain];  
    _inputLayer = [[InputLayer node] retain];
    
    [self addChild:_entityLayer z:10];
    [self addChild:_inputLayer z:20];
    
    
    Grid* grid = [Grid node];
    grid.lineColor = ccc4(0, 225, 150, 150);
    grid.lineSpacing = 120;
    grid.lineWidth = 0.5;
    [_entityLayer addChild:grid z:-2];
     

    _backgroundNode = [BackgroundNode backgroundNodeWithFile:@"Starfield3.png" position:ccp(0,0)];
    [self addChild:_backgroundNode z:0];
}

-(void) createEntitiesAndControllers
{
    _entities = [[CCArray array] retain];
    _controllers = [[CCArray array] retain];
    
    Ship* player = [[Ship shipWithName:@"AssaultFighter1" position:ccp(0, 0) rotation:0] retain];
    Ship* aiShip = [[Ship shipWithName:@"HeavyCruiser2" position:ccp(300, 180) rotation:0] retain];
    
    _cameraController = [[CameraController cameraControllerWithTrackedEntity:player] retain];
    _playerController = [[PlayerController playerControllerWithShip:player] retain];
    AIShipController* aiShipController = [[AIShipController aiShipControllerWithShip:aiShip] retain];
    
    [self addEntity:player];
    [self addEntity:aiShip];
    [self addController:_cameraController];
    [self addController:_playerController];
    [self addController:aiShipController];
    
    [self setScenePosition:player.sprite.position];
    
    _dust = [CCParticleSystemQuad particleWithFile:@"StarDust.plist"];
    [self addChild:_dust z:1];    
}

-(void) dealloc
{
    [self unschedule: @selector(update:)];    
        
    Entity* entity;
    CCARRAY_FOREACH(_entities, entity) {
        [entity release];
    }
    
    Controller* controller;
    CCARRAY_FOREACH(_controllers, controller) {
        [controller release];
    }

    [_entities release];
    [_controllers release];
    [_entityLayer release];
    [_inputLayer release];
    
    delete _contactListener;
    delete _world;
    
    [super dealloc];
}

#pragma mark GameScene - Setters

-(void) setScenePosition:(CGPoint)position
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint centerOfScreen = ccp(winSize.width * 0.5, winSize.height * 0.5);
    CGPoint prevPosition = _entityLayer.position;
    CGPoint newPosition = ccpSub(centerOfScreen, position);
    CGPoint speed = ccpSub(newPosition, prevPosition);
    
    _entityLayer.position = newPosition;
    
    newPosition = ccp(newPosition.x / 15, newPosition.y / 15);
    
    [_backgroundNode setTexturePosition:newPosition];
    _dust.gravity = ccp(speed.x * 10, speed.y * 10);

}

#pragma mark GameScene - Add Objects

-(void) addEntity:(Entity*)entity
{
    [_entities addObject:entity];
    [_entityLayer addEntity:entity];
}

-(void) addController:(Controller*)controller
{
    [_controllers addObject:controller];
}


#pragma mark GameScene - Transforms

-(CGPoint) convertGLToWorldSpace:(CGPoint)glLocation
{
    return ccpSub(glLocation, _entityLayer.position);
}

#pragma mark GameScene - Step

-(void) step:(ccTime) dt
{   
    static float fixedTimeStep = 1.0/60.0;
    static float timeAccumulator = 0.0f;
    
    float timeToRun = dt + timeAccumulator;
    while (timeToRun >= fixedTimeStep) {

        _world->Step(fixedTimeStep, 10, 10);
        
        Controller* controller;
        CCARRAY_FOREACH(_controllers, controller) { 
            [controller step:fixedTimeStep]; 
        }
        
        Entity* entity;
        CCARRAY_FOREACH(_entities, entity) { 
            [entity step:fixedTimeStep]; 
        }
        
        timeToRun -= fixedTimeStep;
    }
    
    timeAccumulator = timeToRun;
}

@end