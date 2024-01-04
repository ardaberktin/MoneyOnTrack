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
    
    var body: some View {
        
        VStack{
            
            Text(authenticationManager.username ?? "No name")
            Text(authenticationManager.user?.email ?? "No email available")
            
            TextField("Updated Username", text: $username)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            
            Button{
                authenticationManager.resetUsername(username: username)
            } label: {
                Text("Update Username")
            }
            
            
            
            Button(action: {
                authenticationManager.logout()
            }, label: {
                Text("Logout")
            })//label
        }
        
    }//body
}//struct

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}
