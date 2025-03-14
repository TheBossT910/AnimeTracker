//
//  AuthView.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-14.
//

import SwiftUI

struct AuthView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Text("AnimeTracker Login Page")
        TextField("Username", text: $username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        SecureField("Password", text: $password)
            .onSubmit {
                //... auto sign-in
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading)
        
        // explicit buttons
        Button("Sign in") {
            //...
        }
        .padding(.bottom)
        
        Button("Sign up") {
            //...
        }
    }
}

#Preview {
    AuthView()
}
