//
//  UserInfo.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-28.
//

import Foundation
import Firebase

class UserInfo{
    @Published private(set) var username: String
    @Published private(set) var email: String?
    @Published private(set) var uid: String
    @Published private(set) var photoURL: String
    
    
    init(username: String, email: String, uid: String, photoURL: String) {
        self.username = username
        self.email = email
        self.uid = uid
        self.photoURL = photoURL
    }//init
    
    func getEmail() -> String? {
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let email = user.email
  
            self.email = email
            return email
        }
        
        return nil
    }

    
}
