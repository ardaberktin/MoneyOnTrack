//
//  LoginWCredentials.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-25.
//

import SwiftUI

struct LoginWCredentials: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var money: Money
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Money on Track")
                .bold()
                .font(.title)
                .foregroundStyle(.white)
            
            TextField("Email", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
                
            LoginButton(text: "Login")
                .onTapGesture {
                    authenticationManager.login(email: email, password: password)
                    money.getFirebase()
                }
                
            
            NavigationLink{
               SignupView()
                    .environmentObject(authenticationManager)
            } label: {
                LoginButton(image: "person.badge.plus", text: "Sign Up")
            }
            
            if(authenticationManager.isUserFound()){
                Button("Resend Verification Email") {
                    authenticationManager.resendVerificationEmail()
                }
            }//if
            
        }//Vstack
        .textFieldStyle(.roundedBorder)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.green,.blue], startPoint: .topTrailing, endPoint: .bottomTrailing)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }//body view
    
}//struct view

#Preview {
    LoginWCredentials()
        .environmentObject(AuthenticationManager())
}
