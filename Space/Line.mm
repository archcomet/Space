//
//  Line.m
//  Space
//
//  Created by Michael Good on 1/26/12.
//  Copyright 2012 none. All rights reserved.
//

#import "Line.h"

@implementation Line

@synthesize lineWidth = lineWidth_;
@synthesize lineColor = lineColor_;
@synthesize startPoint = startPoint_;
@synthesize endPoint = endPoint_;


+(Line*) lineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    Line* line = [self node];
    
    line.startPoint = startPoint;
    line.endPoint = endPoint;
    
    return line;
}

-(id) init
{
    if ((self = [super init]))
    {
        lineWidth_ = 1.0;
        lineColor_ = ccc4(255, 255, 255, 255);        
    }
    return self;
}


-(void) drawLineFrom:(ccVertex2F)p1 to:(ccVertex2F)p2
{    
    ccVertex2F vertices[2] = { p1, p2 };
    ccColor4B colors[2] = {lineColor_, lineColor_};
    
    glLineWidth(lineWidth_);
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    glDrawArrays(GL_LINES, 0, 2);
}

-(void) draw 
{   
    ccVertex2F p1 = {startPoint_.x * CC_CONTENT_SCALE_FACTOR(), 
        startPoint_.y * CC_CONTENT_SCALE_FACTOR()};
    
    ccVertex2F p2 = {endPoint_.x * CC_CONTENT_SCALE_FACTOR(), 
        endPoint_.y * CC_CONTENT_SCALE_FACTOR()};
    
    
    // Disable unneeded states
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    // Enabled blend function
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_LINE_SMOOTH);
    
    // draw the line
    if (lineWidth_ > 0.0) {
        [self drawLineFrom:p1 to:p2];
    }
    
    // Disable blend functions
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    glDisable(GL_LINE_SMOOTH);
    
    // Restore default states for Cocos2d
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	    
}

@end
