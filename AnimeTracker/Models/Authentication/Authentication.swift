//
//  Authentication.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-14.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    static let shared = AuthManager()       // singleton instance
    @Published var userID: String? = nil    // store user id
    
    init() {
        self.userID = Auth.auth().currentUser?.uid  // gets the current logged-in user, if any
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // try to get the user's id
            if let user = authResult?.user {
                self.userID = user.uid
            }
        }
    }
    
    func signOut() throws {
        // sign out the current user
        do {
            try Auth.auth().signOut()
            self.userID = nil
        } catch {
            print("Error signing user out: \(error.localizedDescription)")
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // grab the user's id (they are also currently signed-in now)
            if let user = authResult?.user {
                self.userID = user.uid
            }
        }
    }
}
