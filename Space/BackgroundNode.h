//
//  BackgroundNode.h
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "cocos2d.h"

@interface BackgroundNode : CCNode {
    
    CCTexture2D* _texture;
    ccVertex2F _vertices[4];
    ccTex2F _texCoords[4];
    
    ccColor4B _color;
    ccBlendFunc _blendFunc;
}

@property (readwrite, nonatomic) ccColor4B color;
@property (readwrite, nonatomic) ccBlendFunc blendFunc;

+(BackgroundNode*) backgroundNodeWithFile:(NSString*)file position:(CGPoint)position;
-(id) initWithFile:(NSString*)file position:(CGPoint)position;
-(void) setTexturePosition:(CGPoint)position;

@end
