//
//  LoginWCredentials.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-25.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    //@State private var isLoginViewPresented = false // Add a state variable to track whether to present the LoginView
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Sign Up to Money on Track")
                    .bold()
                    .font(.title)
                    .foregroundStyle(.white)
                
                TextField("Name", text: $name)
                    .disableAutocorrection(true)
                
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                LoginButton(text: "Sign Up")
                    .onTapGesture {
                        authenticationManager.signup(email: email, password: password, username: name)
                        //isLoginViewPresented = true // Set the flag to present the LoginView
                    }
            }//VStack
            .textFieldStyle(.roundedBorder)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                LinearGradient(colors: [.green, .blue], startPoint: .topTrailing, endPoint: .bottomTrailing)
            }
            .edgesIgnoringSafeArea(.all)
        }//navigationView
    }//body view
}//struck

#Preview {
    SignupView()
        .environmentObject(AuthenticationManager())
}

