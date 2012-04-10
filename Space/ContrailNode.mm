//
//  ContrailNode.mm
//  Space
//
//  Created by Michael Good on 3/19/12.
//  Copyright 2012 none. All rights reserved.
//

#import "ContrailNode.h"
#import "GameScene.h"

@implementation ContrailNode

@synthesize color = _baseColor;
@synthesize offset = _offset;
@synthesize enabled = _enabled;
@synthesize width = _width;
@synthesize minSpeed = _minSpeed;
@synthesize maxDeltaX = _maxDeltaX;
@synthesize fadeSpeed = _fadeSpeed;
@synthesize interval = _interval;

+(ContrailNode*) contrailWithVehicle:(Vehicle*)vehicle
{
    return [[[self alloc] initWithVehicle:vehicle] autorelease];
}

-(id) initWithVehicle:(Vehicle *)vehicle
{
    if ((self = [super init])) 
    {
        _vehicle = vehicle;
        
        _baseColor = (ccColor3B) { 255, 255, 255 };
        _segments = 25;
        _fadeSpeed = 2;
        _interval = 6;
        _steps = 0;
        _alpha = 0;
        _width = 3.0;
        _minSpeed = 3.0;
        _maxDeltaX = -0.55;
        _offset = ccp(0, 0);

        _points = (ccVertex2F*) malloc((_segments+1) * sizeof(ccVertex2F));
        _colors = (ccColor4B*) malloc((_segments+1) * sizeof(ccColor4B));
        
        for (int i = 0; i < _segments+1; i++)
        {
            _points[i] = (ccVertex2F) { _vehicle.sprite.position.x, _vehicle.sprite.position.y };
            _colors[i] = (ccColor4B) { _baseColor.r, _baseColor.g, _baseColor.b, 0 };
        }
        
        [[[GameScene sharedGameScene] entityLayer] addChild:self z:-1];
    }
    return self;
}

-(void) updateContrail
{   
    float rotation =  CC_DEGREES_TO_RADIANS(_vehicle.sprite.rotation);
    CGPoint position = _vehicle.sprite.position;
    
    // Rotate offset vector
    CGPoint offset = ccp(0, 0);
    if (_offset.x != 0.0 || _offset.y != 0.0) {
        offset.x = _offset.x * cosf(rotation) + _offset.y * sinf(rotation);
        offset.y = -_offset.x * sinf(rotation) + _offset.y * cosf(rotation); 
    }

    // Calculate contrail point
    CGPoint point = ccpAdd(position, offset);
    
    bool enabled = (_vehicle.steeringBehavior != kSteeringBehaviorIdle);
    if (enabled) {
        
        b2Vec2 velocity = _vehicle.body->GetLinearVelocity();
        float speed = velocity.Length(); 
        enabled = (speed > _minSpeed);
        
        if (enabled) {
            float deltaX = ccpDot(ccp(velocity.x, velocity.y), offset) / (speed * ccpLength(offset));
            enabled = (deltaX < _maxDeltaX);
        }
    }
    
    // Determine alpha value to be used.
    if (enabled) {
        _alpha = (_alpha > 255 - _fadeSpeed) ? 255 : _alpha + _fadeSpeed;
    }
    else {
        _alpha = 0;
    }
    
    // Apply position, color, and alpha to contrail
    _points[_segments] = (ccVertex2F) { point.x, point.y };
    _colors[_segments] = (ccColor4B) { _baseColor.r,_baseColor.g, _baseColor.b, _alpha };
    
    // If enough steps have passed, move points down the array
    if (_steps > _interval) {
        memcpy(_points, _points+1, _segments * sizeof(ccVertex2F));
        memcpy(_colors, _colors+1, _segments * sizeof(ccColor4B));
        _steps = 0;
    }
    else {
        _steps++;
    }
    
    // Fade all points
    for (int i = 0; i < _segments+1; i++) {
        _colors[i].a = (_colors[i].a < _fadeSpeed) ? 0 : _colors[i].a - _fadeSpeed;
    }
}

-(void) draw
{    
    [self updateContrail];
    
    // Disable unneeded states
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    // Enabled blend function
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_LINE_SMOOTH);
    
    glLineWidth(_width);

    glVertexPointer(2, GL_FLOAT, 0, _points);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, _colors);
    glDrawArrays(GL_LINE_STRIP, 0, _segments+1);

    // Disable blend functions
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    glDisable(GL_LINE_SMOOTH);
    
    // Restore default states for Cocos2d
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

@end
