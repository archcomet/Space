//
//  Callbacks.h
//  Space
//
//  Created by Michael Good on 4/18/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#ifndef CALLBACKS_H
#define CALLBACKS_H

#import "Common.h"
#include <Box2D.h>
#include <vector>

using namespace std;

class QueryCallback : public b2QueryCallback {
private:
    EntityCategory _category;
    
public:
    vector<b2Body*> foundBodies;

    QueryCallback(EntityCategory category) { _category = category; }
    
    bool ReportFixture(b2Fixture* fixture) {
        b2Filter filter = fixture->GetFilterData();
        if ((filter.maskBits & _category) == _category) {
            foundBodies.push_back( fixture->GetBody() );
        }
        return true;
    }
};

#endif