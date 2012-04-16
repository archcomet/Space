//
//  GameScene.mm
//  Space
//
//  Created by Michael Good on 2/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import "GameScene.h"
#import "TestRenderIndicatorBar.h"
#import "PlayerComponent.h"
#import "AIShipComponent.h"

@interface GameScene (Hidden)
-(void) startScene;
-(void) createWorld;
-(void) createSpriteFrameCache;
-(void) createLayers;
-(void) createEntitiesAndControllers;
@end

@implementation GameScene
@synthesize world = _world;
@synthesize player = _player;
@synthesize entityLayer = _entityLayer;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize cameraController = _cameraController;

#pragma mark GameScene - Memory Management

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
    
    TestRenderIndicatorBar* test = [TestRenderIndicatorBar node];
    [self addChild:test z:100];
    
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
    _backgroundLayer = [BackgroundLayer backgoundLayer];
    _entityLayer = [EntityLayer entityLayerWithFile:@"SpaceShips.png"];  
    _inputLayer = [InputLayer node];
    
    [self addChild:_backgroundLayer z:0];
    [self addChild:_entityLayer z:10];
    [self addChild:_inputLayer z:20];
}

-(void) createEntitiesAndControllers
{
    _entities = [[CCArray array] retain];
    _entityFactory = [[EntityFactory entityFactor] retain];
    
    Entity* player = [_entityFactory loadEntityWithName:@"AssaultFighter1"];
    Entity* aiShip = [_entityFactory loadEntityWithName:@"HeavyCruiser2"];
    
    [_entities addObject:player];
    [_entities addObject:aiShip];
    
    AIShipComponent* aiShipComponent = [AIShipComponent aiShipComponentWithEntity:aiShip];
    [aiShip addComponent:aiShipComponent];
    [aiShipComponent bind];
    
    PlayerComponent* playerComponent = [PlayerComponent playerComponentWithEntity:player];
    [player addComponent:playerComponent];
    [playerComponent bind];
    
    [player spawnEntityWithPosition:ccp(0,0) rotation:0];
    [aiShip spawnEntityWithPosition:ccp(300,180) rotation:0];
    
    _player = player;
    _inputLayer.playerComponent = playerComponent;
    
    _cameraController = [[CameraController cameraController] retain];    
    [_cameraController trackEntity:player];
    [_cameraController setPosition:player.position];
}

-(void) dealloc
{
    [self unschedule: @selector(update:)];    
        
    [_entities removeAllObjects];
    [_entities release];
    [_entityFactory release];
    [_cameraController release];
    
    delete _contactListener;
    delete _world;
    
    [self removeAllChildrenWithCleanup:true];
    [super dealloc];
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
        
        Entity* entity;
        CCARRAY_FOREACH(_entities, entity) { 
            [entity step:fixedTimeStep]; 
        }
        
        [_cameraController step:fixedTimeStep];
        
        timeToRun -= fixedTimeStep;
    }
    
    timeAccumulator = timeToRun;
}

@end