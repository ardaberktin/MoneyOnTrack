//
//  ProfileView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    @State private var username = ""
    @State private var isBiometricsOn = false
    
    var body: some View {
        
        VStack{
            List{
                Section{
                    Text(authenticationManager.username ?? "No name")
                    Text(authenticationManager.user?.email ?? "No email available")
                }//Section
                
                Section{
                    TextField("Enter New Username", text: $username)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button{
                        authenticationManager.resetUsername(username: username)
                    } label: {
                        Text("Update Username")
                    }//label
                }//Section
                
                Toggle(isOn: $isBiometricsOn) {
                    Text("FaceID")
                }//Toggle
                .onChange(of: isBiometricsOn) { old,newValue in
                    // Handle the change in biometrics toggle
                    if newValue {
                        // Biometrics is turned on
                        authenticationManager.enableBiometricAuth()
                    } else {
                        // Biometrics is turned off
                        authenticationManager.disableBiometricAuth()
                    }
                }
                
                Button(action: {
                    authenticationManager.logout()
                }, label: {
                    Text("Logout")
                })//label
            }//List
        }//VStack
        .onAppear {
            // Read the existing biometrics setting and update the state
            isBiometricsOn = authenticationManager.isBiometricsOn
        }
        
    }//body
}//struct

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}
