//
//  LoginView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    var body: some View {
        VStack{
            
            LoginTitle()
                .padding(.bottom, 70)
            
            
            switch
            authenticationManager.biometryType{
            case .faceID:
                LoginButton(image: "faceid", text: "Unlock with FaceID")
                .onTapGesture {
                     Task.init {
                          await authenticationManager.authenticateWithBiometrics()
                      }
                }
                
                NavigationLink{
                   LoginWCredentials()
                        .environmentObject(authenticationManager)
                } label: {
                    LoginButton(image: "person.fill", text: "Login with your credentials")
                }
                
            case .touchID:
                LoginButton(image: "touchid", text: "Unlock with TouchID")
                .onTapGesture {
                     Task.init {
                          await authenticationManager.authenticateWithBiometrics()
                      }
                }
                
                NavigationLink{
                   LoginWCredentials()
                        .environmentObject(authenticationManager)
                } label: {
                    LoginButton(image: "person.fill", text: "Login with your credentials")
                }
                
            default:
                NavigationLink{
                   LoginWCredentials()
                        .environmentObject(authenticationManager)
                } label: {
                    LoginButton(image: "person.fill", text: "Login with your credentials")
                }
            
            }//switch
            
        }//Vstack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.green,.blue], startPoint: .topTrailing, endPoint: .bottomTrailing)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }//body view
}//struct view

#Preview {
    LoginView()
        .background {
            LinearGradient(colors: [.green,.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .environmentObject(AuthenticationManager())
}
