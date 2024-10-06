//
//  ForgotPasswordView.swift
//  MoneyOnTrack
//
//  Created by Arda Berktin on 2024-06-08.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var money: Money
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Money on Track")
                .bold()
                .font(.title)
                .foregroundStyle(.white)
            
            Text("Reset Password")
                .bold()
                .font(.title3)
                .foregroundStyle(.white)
            
            TextField("Email", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
         
                
            LoginButton(text: "Send Reset Email ")
                .onTapGesture {
                    authenticationManager.forgotPassword(email: email)
                    money.getFirebase()
                }
            
            NavigationLink{
                LoginWCredentials()
                    .environmentObject(authenticationManager)
                
            }label: {
                Text("Remember your password? ")
                    .foregroundStyle(.white)
                Text("Log in")
                    .foregroundStyle(.white)
                    .underline()
            }
          
            
        }//Vstack
        .textFieldStyle(.roundedBorder)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.green,.blue], startPoint: .topTrailing, endPoint: .bottomTrailing)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }//body view
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthenticationManager())
}
