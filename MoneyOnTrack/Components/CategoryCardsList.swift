//
//  CategoryCardsList.swift
//  MoneyOnTrack
//
//  Created by Arda Berktin on 2024-01-03.
//

import SwiftUI

struct CategoryCardsList: View {
    
    @EnvironmentObject var money: Money
    @State private var gridcolumns = Array(repeating: GridItem(.flexible()), count: 2)
    @Binding var isEditing: Bool  // Add binding for isEditing
    
    
    // Sort the keys of the dictionary
    var sortedCategories: [String]
    
    var body: some View {
        LazyVGrid(columns: gridcolumns, spacing: 25){
            
            ForEach(sortedCategories, id: \.self) { category in
                
                ZStack(alignment: .topTrailing){
                    NavigationLink(destination: AddDetailView(categoryName: category)){
                        
                        CategoryCards(categoryName: category)
                            .environmentObject(money)
                     
                    }//NavigationLink
                    .disabled(isEditing)
                    
                        if isEditing {
                            Button {
                                withAnimation {
                                    money.removeCategory(category)
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(Font.title)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, Color.red)
                                    
                            }//label
                            .offset(x: 24, y: -15)

                        }//if
    
                    }//Zstack

            }//ForEach
        }//LazyVGrid
        .padding(.top)
    }
}

#Preview {
    CategoryCardsList(isEditing: .constant(false), sortedCategories: ["Travel","Health"])  // Example usage, you can set isEditing accordingly
        .environmentObject(Money())
}
