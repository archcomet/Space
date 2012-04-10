//
//  ContactListener.mm
//  Space
//
//  Created by Michael Good on 3/31/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "ContactListener.h"
#import "Entity.h"

ContactListener::ContactListener() {
}

ContactListener::~ContactListener() {
}

void ContactListener::BeginContact(b2Contact* contact) {    
    
    Entity* entityA = (Entity*) contact->GetFixtureA()->GetBody()->GetUserData();
    Entity* entityB = (Entity*) contact->GetFixtureB()->GetBody()->GetUserData();
    
    if (entityA != NULL && entityB != NULL) {
        b2Manifold* manifold = contact->GetManifold();
        [entityA beginContactWithEntity:entityB manifold:manifold];
        [entityB beginContactWithEntity:entityA manifold:manifold];
    }
}

void ContactListener::EndContact(b2Contact* contact) {
    
    Entity* entityA = (Entity*) contact->GetFixtureA()->GetBody()->GetUserData();
    Entity* entityB = (Entity*) contact->GetFixtureB()->GetBody()->GetUserData();
    
    if (entityA != NULL && entityB != NULL) {
        b2Manifold* manifold = contact->GetManifold();
        [entityA endContactWithEntity:entityB manifold:manifold];
        [entityB endContactWithEntity:entityA manifold:manifold];
    }
}

void ContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
}

void ContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse* impulse) {
    
}
