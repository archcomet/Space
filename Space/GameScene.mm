//
//  GameScene.mm
//  Space
//
//  Created by Michael Good on 2/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import "GameScene.h"
#import "TestRenderIndicatorBar.h"

@interface GameScene (Hidden)
-(void) startScene;
-(void) createWorld;
-(void) createSpriteFrameCache;
-(void) createLayers;
-(void) createEntitiesAndControllers;
-(void) endScene;
@end

@implementation GameScene
@synthesize world = _world;
@synthesize entityLayer = _entityLayer;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize gameCamera = _gameCamera;

#pragma mark GameScene - Memory Management

+(GameScene*) sharedGameScene
{
    static GameScene *sharedGameScene;
    @synchronized(self) {
        if (!sharedGameScene) {
            sharedGameScene = [[self alloc] init];
            [sharedGameScene startScene];
        }
        return sharedGameScene;
    }
}

#pragma mark GameScene - Start Scene

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
    _entityFactory = [EntityFactory sharedEntityFactory];
    
    Entity* player = [_entityFactory createEntityWithName:@"AssaultFighter1" category:kEntityCategoryPlayer];
    Entity* aiShip = [_entityFactory createEntityWithName:@"HeavyCruiser2" category:kEntityCategoryHostile];
    
    [player spawnEntityWithPosition:ccp(0,0) rotation:0];
    [aiShip spawnEntityWithPosition:ccp(300,180) rotation:0];
    
    [_inputLayer setControlledEntity:player];
    
    _gameCamera = [[Camera camera] retain];    
    [_gameCamera trackEntity:player];
    [_gameCamera setPosition:player.position];
}

-(void) endScene
{
    delete _contactListener;
    delete _world;
    
    [_gameCamera release];
    [self unschedule: @selector(update:)];    
    [self removeAllChildrenWithCleanup:true];
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
        for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
            if (b->GetUserData() != NULL) {
                Entity *entity = (Entity*)b->GetUserData(); 
                b2Vec2 position = b->GetPosition();
                entity.position = ccp(position.x * PTM_RATIO, position.y * PTM_RATIO);
                entity.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            } 
        }
        
        Entity* entity;
        CCARRAY_FOREACH(_entityFactory.entities, entity) { 
            [entity step:fixedTimeStep]; 
        }
        
        [_gameCamera step:fixedTimeStep];
        
        timeToRun -= fixedTimeStep;
    }
    
    timeAccumulator = timeToRun;
}

@end