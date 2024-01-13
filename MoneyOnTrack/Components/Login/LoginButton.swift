//
//  LoginButton.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-25.
//

import SwiftUI

struct LoginButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var image: String?
    var showImage = true
    var text: String
    
    var body: some View {
        HStack{
            if showImage{
                Image(systemName: image ?? "person.fill")
                
            }//if
            
            Text(text)
                .font(.callout.bold())

        }//HStack
        .padding()
        .foregroundColor(.black) //so that the text doesn't disappear in dark mode
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(30)
        .shadow(radius: 10)
//        .shadow(color: colorScheme == .dark ? .white : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/) //change the color shadow in dark mode
        
    }// body view
}//struct loginButton

#Preview {
    LoginButton(image: "faceid", showImage: true, text: "Unlock with FaceID")
}
