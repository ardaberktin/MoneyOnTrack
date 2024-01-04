//
//  TabBarItem.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

import SwiftUI

struct Toolbar: ViewModifier {
    @State var isAddViewPresented = false
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink{
                        ProfileView()
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            if(authenticationManager.username != ""){
                                Text(authenticationManager.username ?? "No name")
                            }
                        }//hstack
                    }//label
                }//toolbaritem
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddViewPresented.toggle()
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle")
                        }
                    }//label
                    .popover(isPresented: $isAddViewPresented) {
                        AddView()
                    }//popover
                }//ToolbarItem
            }//toolbar
        
    }// body view
}//struct ViewModifier

extension View {
    func MyToolbar() -> some View {
        modifier(Toolbar())
            .environmentObject(AuthenticationManager())
    }
}

//            .toolbarColorScheme(.dark, for: .navigationBar) //Makes text white by inverting the default background
//            .toolbarBackground(.green,for: .navigationBar)// color of the background
//            .toolbarBackground(.visible, for: .navigationBar) //makes background color visible

