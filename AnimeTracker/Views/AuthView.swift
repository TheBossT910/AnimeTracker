//
//  AuthView.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-14.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var signUpMode: Bool = false

    var body: some View {
        NavigationStack {
            if (!authManager.isAuthenticated && !signUpMode) {
                Text("Welcome to **your** AnimeTracker")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                
                SecureField("Password", text: $password)
                    .onSubmit {
                        // auto sign-in
                        authManager.signIn(email: email, password: password)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                // explicit buttons
                Button("Sign in") {
                    authManager.signIn(email: email, password: password)
                }
                .disabled(email == "" || (password.count < 6) || password == "")
                .padding()
                .font(.title2)
                
                Button("Sign up") {
                    signUpMode = true
                }
            }
            
            else if (signUpMode) {
                Text("Create an account!")
                    .font(.title)
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.leading)
                Text("Must **create a username**.")
                    .font(.caption)
                    .padding(.bottom)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.leading)
                Text("Must use a **valid email address**. i.e. example@anime.com")
                    .font(.caption)
                    .padding(.bottom)
                
                SecureField("Password", text: $password)
                    .onSubmit {
                        // auto sign-in
                        authManager.signIn(email: email, password: password)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                Text("Passwords must have **6+ characters**.")
                    .font(.caption)
                
                Button("Sign up") {
                    authManager.signUp(email: email, password: password, username: username)
                    signUpMode = false
                }
                .disabled(email == "" || (password.count < 6) || password == "" || username == "")
            }
            
            
            else {
                Text("Authenticated!")
                // TODO: does not show userName on ContentView screen when you initially load it
                Text ("Welcome back, \(username)")
                    .padding()
                
                //sign out button
                Button("Sign out") {
                    authManager.signOut()
                    email = ""
                    password = ""
                    username = ""
                }
                .tint(Color.red)
            }
        }
        .onReceive(authManager.$isAuthenticated) { newValue in
            print("Auth state changed: \(newValue)") // Debugging print
        }
        .onReceive(authManager.$userName) { newValue in
            username = newValue ?? "User"
            print("Username changed: \(newValue ?? "None")") // Debugging print
        }
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    AuthView()
        .environmentObject(db)
        .environmentObject(authManager)
}
