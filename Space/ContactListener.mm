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
    
    //Entity* entityA = (Entity*) contact->GetFixtureA()->GetBody()->GetUserData();
    //Entity* entityB = (Entity*) contact->GetFixtureB()->GetBody()->GetUserData();
}

void ContactListener::EndContact(b2Contact* contact) {
    
   // Entity* entityA = (Entity*) contact->GetFixtureA()->GetBody()->GetUserData();
   // Entity* entityB = (Entity*) contact->GetFixtureB()->GetBody()->GetUserData();
}

void ContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
}

void ContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse* impulse) {
    
}
