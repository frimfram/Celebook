//
//  User.swift
//  Celebook
//
//  Created by Jean Ro on 4/2/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation
import FirebaseAuth

struct CelebookUser {
    let uid: String
    let email: String?
    let displayName: String
    
    init(authData: User) {
        self.uid = authData.uid
        self.email = authData.email
        self.displayName = authData.displayName ?? "User"
    }
    
    init(uid: String, email: String?, name: String) {
        self.uid = uid
        self.email = email
        self.displayName = name
    }
}
