//
//  Grid.mm
//  Space
//
//  Created by Michael Good on 2/7/12.
//  Copyright 2012 none. All rights reserved.
//

#import "Grid.h"
#import "GameScene.h"

@implementation Grid

@synthesize lineColor = lineColor_;
@synthesize lineSpacing = lineSpacing_;
@synthesize lineWidth = lineWidth_;

-(id) init
{
    if ((self = [super init]))
    {
        lineColor_ = ccc4(255, 255, 255, 255);
        lineSpacing_ = 40.0;
        lineWidth_ = 1.0;
    }
    return self;
}

-(CGRect) getVisibleArea
{        
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return CGRectMake(self.parent.position.x * -1.0, self.parent.position.y * -1.0, winSize.width, winSize.height);
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

-(void) drawLines
{
    CGRect viewArea  = [self getVisibleArea];
    ccVertex2F p1, p2;
    
    // Vertical lines
    p1.x = floorf(viewArea.origin.x/lineSpacing_) * lineSpacing_;
    p1.y = CGRectGetMinY(viewArea);
    
    p2.x = p1.x;
    p2.y = CGRectGetMaxY(viewArea);
        
    for (int i=0; i < viewArea.size.width / lineSpacing_; i++) {
        p1.x = p2.x += lineSpacing_;
        [self drawLineFrom:p1 to:p2];
    }
    
    // Horizontal lines
    p1.x = CGRectGetMinX(viewArea);
    p1.y = floorf(viewArea.origin.y/lineSpacing_) * lineSpacing_;
    
    p2.x = CGRectGetMaxX(viewArea);
    p2.y = p1.y;
    
    for (int i=0; i < viewArea.size.height / lineSpacing_; i++) {
        p1.y = p2.y += lineSpacing_;
        [self drawLineFrom:p1 to:p2];
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
    
    if (lineWidth_ > 0) {
        [self drawLines];
    }
        
    // Disable blend functions
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);    
    glDisable(GL_LINE_SMOOTH);

    // Restore default states for Cocos2d
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}


@end
