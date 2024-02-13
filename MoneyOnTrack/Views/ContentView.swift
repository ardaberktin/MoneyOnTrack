//
//  ContentView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

import SwiftUI
import LocalAuthentication


struct ContentView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var money: Money
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State var selectedTab = 0
    @State private var navigateToLogin = false

    var body: some View {
        
        NavigationView{
            VStack{
                if authenticationManager.isUserLoggedIn && authenticationManager.isAuthenticated{
                    TabView(selection: $selectedTab) {
                        
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                                
                            }.tag(0)
                        
                        
                        MoneyTrackView()
                            .tabItem {
                                Label("Track", systemImage: "banknote.fill")
                                
                            }.tag(1)
                        
                        BudgetView()
                            .tabItem {
                                Label("Budget", systemImage: "chart.bar.fill")
                            }.tag(2)
                        
                        AIView()
                            .tabItem {
                                Label("AI", systemImage: "bolt.horizontal.fill")
                            }.tag(3)
                        
                    }//tabview
                    //.MyToolbar()
                }else {
                    LoginView()
                        .environmentObject(authenticationManager)
                    
                }
            }//VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $authenticationManager.showAlert){
                Alert(
                    title: Text(authenticationManager.alertTitle ?? "Error"),
                    message: Text(authenticationManager.errorDescription ?? "Error trying to log in with credentials, please try again."),
                    dismissButton: .default(Text("Dismiss")){
                    }
                )
            }//alert
            .onAppear{
                if(authenticationManager.isUserLoggedIn && authenticationManager.isBiometricsOn){
                    print(authenticationManager.isBiometricsOn)
                    Task.init {
                        await authenticationManager.authenticateWithBiometrics()
                    }//Task.init
                }//if
            }//onAppear
            
        }//NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }//body view
    
}//struct view

#Preview {
    ContentView(selectedTab: 2)
        .environmentObject(AuthenticationManager())
        .environmentObject(Money())

}
