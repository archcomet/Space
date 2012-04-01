//
//  MathHelper.h
//  Space
//
//  Created by Michael Good on 3/9/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#define PI  3.14159265f

float inline angleFromVector(b2Vec2 vector)
{
    if (fabsf(vector.x) < FLT_EPSILON) {
        if (vector.y > 0.0f) return 1.570796325f; // PI * 0.5
        if (vector.y < 0.0f) return 4.712388975f; // PI * 1.5
        return 0.0f;
    }
    float radians = atan(vector.y/vector.x);
    return (vector.x < 0.0f) ? radians + PI : radians;
}

float inline arcHorizontal(b2Vec2 v1, b2Vec2 v2)
{
    float v1Length = v1.Length();
    float v2Length = v2.Length();
    
    if (v1Length < FLT_EPSILON || v2Length < FLT_EPSILON) return 0.0;
    
    return b2Dot(v1, v2) / (v1Length * v2Length);
}

b2Vec2 inline truncateVector(b2Vec2 vec, float maxLength)
{
    if (vec.Length() > maxLength) {
        vec.Normalize();
        vec *= maxLength;
    }
    return vec;
}
