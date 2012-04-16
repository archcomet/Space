//
//  BackgroundNode.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"

@implementation Background

@synthesize color = _color;
@synthesize blendFunc = _blendFunc;

+(Background*) backgroundWithFile:(NSString*)file position:(CGPoint)position
{
    return [[[self alloc] initWithFile:file position:position] autorelease];
}

-(id) initWithFile:(NSString*)file position:(CGPoint)position
{
    if ((self = [super init]))
    {
        _texture = [[[CCTextureCache sharedTextureCache] addImage: file] retain];
        ccTexParams tp2 = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        [_texture setTexParameters:&tp2];
        
        _blendFunc = (ccBlendFunc) { CC_BLEND_SRC, CC_BLEND_DST };
        _color = (ccColor4B) { 255, 255, 255, 255 };
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float x1 = 0.0; float x2 = winSize.width;
        float y1 = 0.0; float y2 = winSize.height;
        
        _vertices[0] = (ccVertex2F) { x1, y2 };
        _vertices[1] = (ccVertex2F) { x2, y2 };
        _vertices[2] = (ccVertex2F) { x1, y1 };
        _vertices[3] = (ccVertex2F) { x2, y1 };
        
        [self setTexturePosition:position];
    }
    return self;
}

-(void) dealloc
{
    [_texture release];    
    [super dealloc];
}

-(void) setTexturePosition:(CGPoint)position
{
    CGSize size = _texture.contentSize;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float u1 = position.x * -1 / size.width;
    float v1 = position.y * -1 / size.height;
    float u2 = u1 + (winSize.width  / size.width);
    float v2 = v1 + (winSize.height / size.height);
    
    _texCoords[0] = (ccTex2F) { u1, v2 };
    _texCoords[1] = (ccTex2F) { u2, v2 };
    _texCoords[2] = (ccTex2F) { u1, v1 };
    _texCoords[3] = (ccTex2F) { u2, v1 };
}

-(void) draw
{    
    bool newBlend = _blendFunc.src != CC_BLEND_SRC || _blendFunc.dst != CC_BLEND_DST;
    if( newBlend ) 
        glBlendFunc( _blendFunc.src, _blendFunc.dst );
    
    glBindTexture(GL_TEXTURE_2D, _texture.name);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glColor4ub(_color.r, _color.g, _color.b, _color.a);
    glVertexPointer(2, GL_FLOAT, 0, _vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, _texCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glEnableClientState(GL_COLOR_ARRAY);
    
    if( newBlend )
        glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

@end
