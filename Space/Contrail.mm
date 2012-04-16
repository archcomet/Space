//
//  ContrailNode.mm
//  Space
//
//  Created by Michael Good on 3/19/12.
//  Copyright 2012 none. All rights reserved.
//

#import "Contrail.h"

@implementation Contrail
@synthesize color = _baseColor;
@synthesize offset = _offset;
@synthesize enabled = _enabled;
@synthesize width = _width;
@synthesize fadeSpeed = _fadeSpeed;
@synthesize interval = _interval;

+(Contrail*) contrailWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef;
{
    return [[[self alloc] initWithEntity:entity contrailDef:contrailDef] autorelease];
}

-(id) initWithEntity:(Entity*)entity contrailDef:(ContrailDef)contrailDef;
{
    if ((self = [super init])) 
    {
        _entity = entity;
        _steps = 0;
        _alpha = 0;
        
        _segments = contrailDef.segments;
        _baseColor = contrailDef.baseColor;
        _fadeSpeed = contrailDef.fadeSpeed;
        _interval = contrailDef.interval;
        _width = contrailDef.width;
        _offset = contrailDef.offset;

        _points = (ccVertex2F*) malloc((_segments+1) * sizeof(ccVertex2F));
        _colors = (ccColor4B*) malloc((_segments+1) * sizeof(ccColor4B));
        
        _enabled = true;
        
        for (int i = 0; i < _segments+1; i++)
        {
            _points[i] = (ccVertex2F) { _entity.position.x, _entity.position.y };
            _colors[i] = (ccColor4B) { _baseColor.r, _baseColor.g, _baseColor.b, 0 };
        }
    }
    return self;
}

-(void) updateContrail
{   
    float rotation =  CC_DEGREES_TO_RADIANS(_entity.rotation);
    CGPoint position = _entity.position;
    
    // Rotate offset vector
    CGPoint offset = ccp(0, 0);
    if (_offset.x != 0.0 || _offset.y != 0.0) {
        offset.x = _offset.x * cosf(rotation) + _offset.y * sinf(rotation);
        offset.y = -_offset.x * sinf(rotation) + _offset.y * cosf(rotation); 
    }

    // Calculate contrail emitter point
    CGPoint point = ccpAdd(position, offset);
    
    // Determine alpha value to be used.
    if (_enabled) {
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
