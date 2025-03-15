//
//  Authentication.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-14.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// TODO: throw errors for the view!
class AuthManager: ObservableObject {
    static let shared = AuthManager()       // singleton instance
    @Published var userID: String? = nil    // store user id
    @Published var userName: String? = nil  // user name
    @Published var isAuthenticated: Bool = false    // if user is signed in
    private var db: Firestore
    
    init() {
        self.db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            self.userID = userID  // gets the current logged-in user, if any
            self.isAuthenticated = true
            self.getUserName(userID: userID)
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // try to get the user's id
            if let user = authResult?.user {
                self.userID = user.uid
                self.isAuthenticated = true
                self.getUserName(userID: user.uid)
//                print("user signed in!")
            }
        }
    }
    
    func signOut() {
        // sign out the current user
        do {
            try Auth.auth().signOut()
            self.userID = nil
            self.userName = nil
            self.isAuthenticated = false
        } catch {
            print("Error signing user out: \(error.localizedDescription)")
        }
    }
    
    func signUp(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // grab the user's id (they are also currently signed-in now)
            if let user = authResult?.user {
                self.userID = user.uid
                self.isAuthenticated = true
                self.userName = username
//                print("user signed up!")
                
                // add a new user data entry into database
                let userData = user_data(user_name: username, favorites: [], dropped: [], completed: [], watching: [], plan_to_watch: [])
                do {
                    try self.db.collection("/user_data/").document(user.uid).setData(from: userData)
                } catch {
                    print("could not create user data in database!")
                }
            }
        }
    }
    
    func getUserName(userID: String) {
        Task {
            self.userName = try await self.db.collection("/user_data/").document(userID).getDocument().data()?["user_name"] as? String ?? "None"
        }
    }
}
