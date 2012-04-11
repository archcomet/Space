//
//  IndicatorBar.mm
//  Space
//
//  Created by Michael Good on 4/10/12.
//  Copyright 2012 none. All rights reserved.
//

#import "IndicatorBar.h"

@interface IndicatorBar (Hidden)
-(void) refreshVertices;
-(void) refreshHorizontalVerticesWithPercent:(float)percent origin:(ccVertex2F)origin maxPoint:(ccVertex2F)maxPoint;
-(void) refreshVerticalVerticesWithPercent:(float)percent origin:(ccVertex2F)origin maxPoint:(ccVertex2F)maxPoint;
@end

@implementation IndicatorBar

@synthesize size = _size;
@synthesize type = _type;
@synthesize boarderWidth = _boarderWidth;
@synthesize dividerWidth = _dividerWidth;
@synthesize value = _value;
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;
@synthesize boarderColor = _boarderColor;

@dynamic barStartColor;
@dynamic barEndColor;
@dynamic dividerStartColor;
@dynamic dividerEndColor;
@dynamic backgroundStartColor;
@dynamic backgroundEndColor;

#pragma mark IndicatorBar - Alloc, Init, and Dealloc

+(IndicatorBar*) indicatorBar  {
    return [[[self alloc] init] autorelease];
}

-(id) init {
    if ((self = [super init])) {
        // Default visible to false. 
        // Recommend setting shape and value properties before setting visible to true.
        [self setVisible:false];
        
        // Defaulf values
        _size = (CGSize) { 0, 0 };
        _type = kBarTypeHorizontal;
        _value = 0;
        _minValue = 0;
        _maxValue = 0;
        _boarderWidth = 0;
        _dividerWidth = 0;
        memset(_barColors, 0, sizeof(_barColors));
        memset(_barVertices, 0, sizeof(_barVertices));
        memset(_dividerColors, 0, sizeof(_dividerColors));
        memset(_dividerVertices, 0, sizeof(_dividerVertices));
        memset(_backgroundColors, 0, sizeof(_backgroundColors));
        memset(_backgroundVertices, 0, sizeof(_backgroundVertices));
        memset(_boarderVertices, 0, sizeof(_boarderVertices));
        _boarderColor = (ccColor4B) { 0, 0, 0, 0 };
        
        _renderBar = false;
        _renderDivider = false;
        _renderBackground = false;
    }
    return self;
}

#pragma mark IndicatorBar - Property Overrides

// If the node is visible then changing shape or value properties will refresh the vertices.
// If the node is NOT visible then changing shape or value properties will NOT refresh the vertices.
// Setting visible to true will refresh the vertices
-(void) setVisible:(BOOL)visible {
    [super setVisible:visible];
    if (self.visible) [self refreshVertices];
}

#pragma mark IndicatorBar - Shape Properties

-(void) setSize:(CGSize)size {
    _size = size;
    if (self.visible) [self refreshVertices];
}

-(void) setType:(BarType)type {
    _type = type;
    if (self.visible) [self refreshVertices];
}

-(void) setBoarderWidth:(float)boarderWidth {
    _boarderWidth = boarderWidth;
    if (self.visible) [self refreshVertices];
}

-(void) setDividerWidth:(float)dividerWidth {
    _dividerWidth = dividerWidth;
    if (self.visible) [self refreshVertices];
}

#pragma mark IndicatorBar - Value Properties

-(void) setValue:(float)value {
    
    if (value > _maxValue) value = _maxValue;
    if (value < _minValue) value = _minValue;
    
    _value = value;
    
    if (self.visible) [self refreshVertices];
}

-(void) setMinValue:(float)minValue {
    _minValue = minValue;
    if (self.visible) [self refreshVertices];
}

-(void) setMaxValue:(float)maxValue {
    _maxValue = maxValue;
    if (self.visible) [self refreshVertices];
}

#pragma mark IndicatorBar - Color Properties

-(ccColor4B) getBarStartColor {
    return _barColors[0];
}

-(ccColor4B) getBarEndColor {
    return _barColors[2];
}

-(ccColor4B) getDividerStartColor {
    return _dividerColors[0];
}

-(ccColor4B) getDividerEndColor {
    return _dividerColors[2];
}

-(ccColor4B) getBackgroundStartColor {
    return _backgroundColors[0];
}

-(ccColor4B) getBackgroundEndColor {
    return _backgroundColors[2];
}

-(void) setBarStartColor:(ccColor4B)color {
    _barColors[0] = color;
    _barColors[1] = color;
}

-(void) setBarEndColor:(ccColor4B)color {
    _barColors[2] = color;
    _barColors[3] = color;
}

-(void) setDividerStartColor:(ccColor4B)color {
    _dividerColors[0] = color;
    _dividerColors[1] = color;
}

-(void) setDividerEndColor:(ccColor4B)color {
    _dividerColors[2] = color;
    _dividerColors[3] = color;
}

-(void) setBackgroundStartColor:(ccColor4B)color {
    _backgroundColors[0] = color;
    _backgroundColors[1] = color;
}

-(void) setBackgroundEndColor:(ccColor4B)color {
    _backgroundColors[2] = color;
    _backgroundColors[3] = color;    
}

#pragma mark IndicatorBar - Refresh Vertices

-(void) refreshVertices
{   
    // Calculate origin
    ccVertex2F origin = (ccVertex2F) { 0 - _size.width * self.anchorPoint.x, 
                                       0 - _size.height * self.anchorPoint.y };
    
    // Calculate max point
    ccVertex2F maxPoint = (ccVertex2F) { origin.x + _size.width,
                                         origin.y + _size.height };
    
    // If there is a visible boarder, set the boarder vertices
    if (_boarderWidth > 0 && _boarderColor.a > 0) {
        _boarderVertices[0] = (ccVertex2F) { origin.x, origin.y };
        _boarderVertices[1] = (ccVertex2F) { origin.x, maxPoint.y };
        _boarderVertices[2] = (ccVertex2F) { maxPoint.x, maxPoint.y };
        _boarderVertices[3] = (ccVertex2F) { maxPoint.x, origin.y };
        _boarderVertices[4] = (ccVertex2F) { origin.x, origin.y };
    }
    
    // Calculate the percent
    float percent = (_value - _minValue) / (_maxValue - _minValue);
    
    // Calculate vertices based on bar type
    if (_type == kBarTypeHorizontal) {
        [self refreshHorizontalVerticesWithPercent:percent origin:origin maxPoint:maxPoint];
    }
    else {
        [self refreshVerticalVerticesWithPercent:percent origin:origin maxPoint:maxPoint];
    }
}

-(void) refreshHorizontalVerticesWithPercent:(float)percent origin:(ccVertex2F)origin maxPoint:(ccVertex2F)maxPoint
{
    // Calculate where the bar and divider ends
    float dividerMaxX = origin.x + _size.width * percent;
    float barMaxX =  dividerMaxX - _dividerWidth;
    
    // Refresh Bar Vertices
    if (barMaxX > origin.x) {
        _barVertices[0] = (ccVertex2F) { origin.x, origin.y };
        _barVertices[1] = (ccVertex2F) { origin.x, maxPoint.y };
        _barVertices[2] = (ccVertex2F) { barMaxX,  origin.y };
        _barVertices[3] = (ccVertex2F) { barMaxX,  maxPoint.y };
        _renderBar = true;
        
        if (barMaxX == maxPoint.x) {
            _renderDivider = false;
            _renderBackground = false;
            return;
        }
    }
    else {
        barMaxX = origin.x;
        _renderBar = false;
    }

    // Refresh Divider Vertices
    if (dividerMaxX > origin.x && _dividerWidth > 0) {
        _dividerVertices[0] = (ccVertex2F) { barMaxX, origin.y };
        _dividerVertices[1] = (ccVertex2F) { barMaxX, maxPoint.y };
        _dividerVertices[2] = (ccVertex2F) { dividerMaxX, origin.y };
        _dividerVertices[3] = (ccVertex2F) { dividerMaxX, maxPoint.y };
        _renderDivider = true;
        
        if (dividerMaxX == maxPoint.x) {
            _renderBackground = false;
            return;
        }
    }
    else {
        dividerMaxX = (_dividerWidth == 0) ? barMaxX : origin.x;
        _renderDivider = false;
    }
    
    // Refresh Background Vertices
    _backgroundVertices[0] = (ccVertex2F) { dividerMaxX, origin.y };
    _backgroundVertices[1] = (ccVertex2F) { dividerMaxX, maxPoint.y };
    _backgroundVertices[2] = (ccVertex2F) { maxPoint.x, origin.y };
    _backgroundVertices[3] = (ccVertex2F) { maxPoint.x, maxPoint.y };
    _renderBackground = true;
}

-(void) refreshVerticalVerticesWithPercent:(float)percent origin:(ccVertex2F)origin maxPoint:(ccVertex2F)maxPoint
{    
    // Calculate where the bar and divider ends
    float dividerMaxY = origin.y + _size.height * percent;
    float barMaxY =  dividerMaxY - _dividerWidth;
    
    // Refresh Bar Vertices
    if (barMaxY > origin.y) {
        _barVertices[0] = (ccVertex2F) { origin.x, origin.y };
        _barVertices[1] = (ccVertex2F) { maxPoint.x, origin.y };
        _barVertices[2] = (ccVertex2F) { origin.x, barMaxY };
        _barVertices[3] = (ccVertex2F) { maxPoint.x, barMaxY };
        _renderBar = true;
        
        if (barMaxY == maxPoint.y) {
            _renderDivider = false;
            _renderBackground = false;
            return;
        }
    }
    else {
        barMaxY = origin.y;
        _renderBar = false;
    }
    
    // Refresh Divider Vertices
    if (dividerMaxY > origin.y && _dividerWidth > 0) {
        _dividerVertices[0] = (ccVertex2F) { origin.x, barMaxY };
        _dividerVertices[1] = (ccVertex2F) { maxPoint.x, barMaxY };
        _dividerVertices[2] = (ccVertex2F) { origin.x, dividerMaxY };
        _dividerVertices[3] = (ccVertex2F) { maxPoint.x, dividerMaxY };
        _renderDivider = true;
        
        if (dividerMaxY == maxPoint.y) {
            _renderBackground = false;
            return;
        }
    }
    else {
        dividerMaxY = (_dividerWidth == 0) ? barMaxY : origin.y;
        _renderDivider = false;
    }
    
    // Refresh Background Vertices
    _backgroundVertices[0] = (ccVertex2F) { origin.x, dividerMaxY };
    _backgroundVertices[1] = (ccVertex2F) { maxPoint.x, dividerMaxY };
    _backgroundVertices[2] = (ccVertex2F) { origin.x, maxPoint.y };
    _backgroundVertices[3] = (ccVertex2F) { maxPoint.x, maxPoint.y };
    _renderBackground = true;
}

#pragma mark IndicatorBar - Draw

-(void) draw
{
    // Disable unneeded states
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    // Enabled blend function
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    // Draw background
    if (_renderBackground) {
        glVertexPointer(2, GL_FLOAT, 0, _backgroundVertices);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, _backgroundColors);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    
    // Draw divider
    if (_renderDivider) {
        glVertexPointer(2, GL_FLOAT, 0, _dividerVertices);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, _dividerColors);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);        
    }
    
    // Draw bar
    if (_renderBar) {
        glVertexPointer(2, GL_FLOAT, 0, _barVertices);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, _barColors);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);      
    }
    
    // Draw boarder
    if (_boarderWidth > 0.0 && _boarderColor.a > 0) {
        glDisableClientState(GL_COLOR_ARRAY);
        glLineWidth(_boarderWidth);
        glColor4ub(_boarderColor.r, _boarderColor.g, _boarderColor.b, _boarderColor.a);
        glVertexPointer(2, GL_FLOAT, 0, _boarderVertices);
        glDrawArrays(GL_LINE_STRIP, 0, 5);
        glEnableClientState(GL_COLOR_ARRAY);
    }

    // Disable blend functions
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    
    // Restore default states for Cocos2d
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

@end