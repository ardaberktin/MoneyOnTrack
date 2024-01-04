//
//  CategoryDetailView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-28.
//

import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject var money: Money
    var categoryName: String
    
    // DateFormatter for formatting dates
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Budget: $" + String(money.getBudget(category: categoryName)))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                
                VStack{
                    ForEach(money.data.filter { $0.category == categoryName && $0.amount > 0 }, id: \.self) { d in
                        
                        VStack{
                            HStack{
                                Image(systemName: money.getSymbolofCategory(category: d.category))
                                    .font(.title2)
                                
                                VStack{
                                    Text("\(d.category): ")
                                        .bold()
                                        .font(.title3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(dateFormatter.string(from: d.date))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                }//VStack
                                Spacer()
                                
                                Text("-$\(d.amount, specifier: "%.1f")")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(.red)
                            }//HStack
                            .padding(.all, 25)
                            .foregroundColor(.black) //so that the text doesn't disappear in dark mode
                            .background(.white)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                            
                        }//VStack
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }//ForEach
                }//VStack
                .padding()
            }//ScrollView
            .navigationTitle(categoryName)
        }//NavigationStack
        
        
    }//body

}//struct

#Preview {
    CategoryDetailView(categoryName: "Travel")
        .environmentObject(Money())
}
