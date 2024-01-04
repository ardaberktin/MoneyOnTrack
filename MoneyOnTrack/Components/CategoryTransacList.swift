//
//  CategoryTransacList.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-28.
//

import SwiftUI

struct CategoryTransacList: View {
    @EnvironmentObject var money: Money
    
//    var data = [
//        EmptyData(amount: 100, category: "Travel"),
//        EmptyData(amount: 200, category: "Shopping"),
//        EmptyData(amount: 300, category: "Health")
//    ]
//    
    var body: some View {
        
        VStack{
            
            if(!money.isAllAmountsEmpty()){
                Text("Your Categories:")
                    .bold()
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                ForEach(Array(money.totalExpenseAmountsByCategory.filter { $0.value > 0 }.keys)
                    .sorted(by: { (category1, category2) in
                        let totalAmount1 = money.totalExpenseAmountsByCategory[category1] ?? 0.0
                        let totalAmount2 = money.totalExpenseAmountsByCategory[category2] ?? 0.0
                        return totalAmount1 > totalAmount2
                    }), id: \.self) { category in
                    // Your existing code for displaying each category
                    let totalAmount = money.totalExpenseAmountsByCategory[category] ?? 0.0
                    // ...
                        ZStack(alignment: .topTrailing){
                            NavigationLink(destination: CategoryDetailView(categoryName: category)){
                                
                                VStack{
                                    HStack{
                                        Image(systemName: money.getSymbolofCategory(category: category))
                                            .font(.title2)
                                        
                                        VStack{
                                            Text("\(category): ")
                                                .bold()
                                                .font(.title3)
                                            
                                            //Text(d.date)
                                            
                                        }//VStack
                                        Spacer()
                                        
                                        Text("-$\(totalAmount, specifier: "%.1f")")
                                            .bold()
                                            .font(.title3)
                                            .foregroundColor(.red)
                                    }//HStack
                                    .padding(.all, 25)
                                    .foregroundColor(.black) //so that the text doesn't disappear in dark mode
                                    .background(.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                                    
                                }//VStack
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            }//NavigationLink
                        }//ZStack
                }//ForEach
            }//if
        }//VStack
        .padding()
        
      
        
        
    }//body
}//struct

#Preview {
    CategoryTransacList()
        .environmentObject(Money())
}
