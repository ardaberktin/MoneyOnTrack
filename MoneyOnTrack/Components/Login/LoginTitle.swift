//
//  TitleView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-25.
//

import SwiftUI

struct LoginTitle: View {
    var body: some View {
        VStack{
            Text("Ready to have your  ")
            Text("Money on Track?")
               
        }//VStack
        .bold()
        .font(.title)
        .foregroundStyle(.white)
        .padding()
    }//body view
}//struct view

#Preview {
    LoginTitle()
        .background {
            LinearGradient(colors: [.green,.blue], startPoint: .topTrailing, endPoint: .bottomTrailing)
        }
}
