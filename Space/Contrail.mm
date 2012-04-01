//
//  Contrail.mm
//  Space
//
//  Created by Michael Good on 3/19/12.
//  Copyright 2012 none. All rights reserved.
//

#import "Contrail.h"
#import "GameScene.h"

@implementation Contrail

@synthesize color = _baseColor;
@synthesize width = _width;
@synthesize minSpeed = _minSpeed;
@synthesize fadeSpeed = _fadeSpeed;
@synthesize interval = _interval;

+(Contrail*) contrailWithSegments:(int)segments position:(CGPoint)position
{
    return [[[self alloc] initWithSegments:segments position:position] autorelease];
}

-(id) initWithSegments:(int)segments position:(CGPoint)position
{
    if ((self = [super init])) 
    {
        _baseColor = (ccColor3B) { 255, 255, 255 };
        _segments = segments;
        _minSpeed = 4;
        _fadeSpeed = 2;
        _interval = 8;
        _steps = 0;
        _alpha = 0;
        _width = 3.0;
        
        _points = (ccVertex2F*) malloc((_segments+1) * sizeof(ccVertex2F));
        _colors = (ccColor4B*) malloc((_segments+1) * sizeof(ccColor4B));
        
        for (int i = 0; i < _segments+1; i++)
        {
            _points[i] = (ccVertex2F) { position.x, position.y };
            _colors[i] = (ccColor4B) { _baseColor.r, _baseColor.g, _baseColor.b, 0 };
        }
        
        [[[GameScene sharedGameScene] entityLayer] addChild:self z:-1];
    }
    return self;
}

-(void) updateWithPosition:(CGPoint)position speed:(int)speed
{
    _points[_segments] = (ccVertex2F) { position.x, position.y };
    if (speed > _minSpeed) {
        _alpha = (_alpha > 255 - _fadeSpeed) ? 255 : _alpha + _fadeSpeed;
        _colors[_segments] = (ccColor4B) { _baseColor.r,_baseColor.g, _baseColor.b, _alpha };
    }
    else {
        _alpha = (_alpha < _fadeSpeed) ? 0 : _alpha - _alpha;
    }
    
    if (_steps > _interval) {
        memcpy(_points, _points+1, _segments * sizeof(ccVertex2F));
        memcpy(_colors, _colors+1, _segments * sizeof(ccColor4B));
        _steps = 0;
    }
    else {
        _steps++;
    }
    
    for (int i = 0; i < _segments+1; i++) {
        _colors[i].a = (_colors[i].a < _fadeSpeed) ? 0 : _colors[i].a - _fadeSpeed;
    }
}

-(void) draw
{    
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
