//
//  PolyLine.mm
//  Space
//
//  Created by Michael Good on 1/27/12.
//  Copyright 2012 none. All rights reserved.
//

#import "PolyLine.h"

@implementation PolyLine

@synthesize fadeWidth = fadeWidth_;

inline double absDbl(double value) { return (value > 0.0) ? value : -value; }


+(PolyLine*) lineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    PolyLine* line = [self node];
    
    line.startPoint = startPoint;
    line.endPoint = endPoint;
    
    return line;
}

-(id) init 
{
    if ((self = [super init]))
    {
        fadeWidth_ = 0.0;
    }
    return self;
}

-(void) setFadeWidth:(float)fadeWidth
{
    fadeWidth_ = (fadeWidth < 0.0) ? 0.0 : fadeWidth;
}

-(void) drawLineFrom:(ccVertex2F)p1 to:(ccVertex2F)p2
{
    double t, R;
    double f = lineWidth_ - static_cast<int>(lineWidth_);
    GLubyte alpha = lineColor_.a;

    // Determine t (core thickness) and R (fading edge thickness)
    if (lineWidth_ >= 0.0 && lineWidth_ < 1.0) {
        t = 0.05; 
        R = 0.48  + 0.32*f;
        alpha *= f;
    } 
    else if (lineWidth_ >= 1.0 && lineWidth_ < 2.0) {
        t = 0.05  + 0.33*f; 
        R = 0.768 + 0.312*f;
    } 
    else if (lineWidth_ >= 2.0 && lineWidth_ < 3.0) {
        t = 0.38  + 0.58*f; 
        R = 1.08;
    } 
    else if (lineWidth_ >= 3.0 && lineWidth_ < 4.0) {
        t = 0.96  + 0.48*f;
        R = 1.08;
    } 
    else if (lineWidth_ >= 4.0 && lineWidth_ < 5.0) {
        t = 1.44 + 0.46*f; 
        R = 1.08;
    } 
    else if (lineWidth_ >= 5.0 && lineWidth_ < 6.0) {
        t = 1.9 + 0.6*f;
        R = 1.08;
    } 
    else if (lineWidth_ >= 6.0) {
        double ff = lineWidth_ - 6.0;
        t = 2.5 + 0.50*ff; 
        R = 1.08;
    }
    
    R += fadeWidth_;
    
    // Calculate angle of line (relative to the horizon)
    double tx = 0, ty = 0; // core thickness
    double Rx = 0, Ry = 0; // fading edge
    double cx = 0, cy = 0; // cap
    double tolerance = 0.01;

    double dx = p2.x - p1.x; 
    double dy = p2.y - p1.y;

    if (absDbl(dx) < tolerance) {
        // Vertical Line
        tx = t; ty = 0;
        Rx = R; Ry = 0;

        if (lineWidth_ > 0.0 && lineWidth_ <= 1.0) {
            tx = 0.4;
        }
        else if (lineWidth_ == 1.0) {
            tx = 0.5;
        }
    }
    else if (absDbl(dy) < tolerance) {
        // Horizontal Line
        tx = 0; ty = t;
        Rx = 0; Ry = R;

        if (lineWidth_ > 0.0 && lineWidth_ <= 1.0) {
            ty = 0.4;
        }
        else if (lineWidth_ == 1.0) {
            ty = 0.5;
        }
    }
    else {
        if ((lineWidth_+fadeWidth_) < 3) {
            // For thin lines, calculate approxmate angle from slope
            double m = dy/dx;
            if (m > -0.4142 && m <= 0.4142) {
                // Angle between -22.5 and 22.5 (~ 0 degrees)
                tx = t * 0.1; 
                ty = t;
                Rx = R * 0.6; 
                Ry = R;
            }
            else if (m > 0.4142 && m <= 2.4142) {
                // Angle between 22.5 and 67.5 (~ 45 degrees)
                tx = t * -0.7071; 
                ty = t * 0.7071;
                Rx = R * -0.7071; 
                Ry = R * 0.7071;
            } 
            else if (m > 2.4142 || m <= -2.4142) {
                // Angle between 67.5 and 112.5 (~ 90 degrees)
                tx = t;
                ty = t * 0.1;
                Rx = R;
                Ry = R * 0.6;
            }
            else if (m > -2.4142 && m < -0.4142) {
                // Angle between 112.5 and 157.6 (~ 135 degrees)
                tx = t * 0.7071; 
                ty = t * 0.7071;
                Rx = R * 0.7071;
                Ry = R * 0.7071;
            } 
        } 
        else { 
            //Calcluate exact angle
            dx = p1.y - p2.y;
            dy = p2.x - p1.x;
            double L = sqrt(dx*dx+dy*dy);
            dx /= L;
            dy /= L;
            cx = -0.6*dy;
            cy =  0.6*dx;
            tx = t*dx; 
            ty = t*dy;
            Rx = R*dx; 
            Ry = R*dy;
        }        
    }

    // Create vertex array for line (triangle strip)
    ccVertex2F lineVertices[] = {
        {p1.x - tx - Rx, p1.y - ty - Ry},
        {p2.x - tx - Rx, p2.y - ty - Ry},
        {p1.x - tx, p1.y - ty},
        {p2.x - tx, p2.y - ty},
        {p1.x + tx, p1.y + ty},
        {p2.x + tx, p2.y + ty},
        {p1.x + tx + Rx, p1.y + ty + Ry},
        {p2.x + tx + Rx, p2.y + ty + Ry}
    };

    // Create color array for line
    ccColor4B lineColors[] = {
        {lineColor_.r, lineColor_.g, lineColor_.b, 0},
        {lineColor_.r, lineColor_.g, lineColor_.b, 0},
        {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
        {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
        {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
        {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
        {lineColor_.r, lineColor_.g, lineColor_.b, 0},
        {lineColor_.r, lineColor_.g, lineColor_.b, 0}
    };

    // Define and draw line
    glVertexPointer(2, GL_FLOAT, 0, lineVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, lineColors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 8);
     
    
    // Draw end cap
    
    if (lineWidth_ > 3 ) {
        // Create vertex array for line cap (triangle strip)
        ccVertex2F capVertices[] = {
            {p1.x - Rx + cx, p1.y - Ry + cy},
            {p1.x + Rx + cx, p1.y + Ry + cy},
            {p1.x - Rx - tx, p1.y - Ry - ty},
            {p1.x + Rx + tx, p1.y + Ry + ty},
            {p2.x - Rx - cx, p2.y - Ry - cy},
            {p2.x + Rx - cx, p2.y + Ry - cy},
            {p2.x - Rx - tx, p2.y - Ry - ty},
            {p2.x + Rx + tx, p2.y + Ry + ty}
        };
         
        // Create color array for line cap
        ccColor4B capColors[] = {
            {lineColor_.r, lineColor_.g, lineColor_.b, 0.0},
            {lineColor_.r, lineColor_.g, lineColor_.b, 0.0},
            {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
            {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
            {lineColor_.r, lineColor_.g, lineColor_.b, 0.0},
            {lineColor_.r, lineColor_.g, lineColor_.b, 0.0},
            {lineColor_.r, lineColor_.g, lineColor_.b, alpha},
            {lineColor_.r, lineColor_.g, lineColor_.b, alpha}
        };
     
        // Define line caps
        glVertexPointer(2, GL_FLOAT, 0, capVertices);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, capColors);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    }
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

    // draw the line
    if (lineWidth_ > 0.0) {
        [self drawLineFrom:p1 to:p2];
    }
    
    // Disable blend functions
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
   
    // Restore default states for Cocos2d
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	    
}

@end
