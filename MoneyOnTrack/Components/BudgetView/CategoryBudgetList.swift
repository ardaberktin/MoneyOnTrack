//
//  CategoryBudgetList.swift
//  MoneyOnTrack
//
//  Created by Arda Berktin on 2024-01-13.
//

import SwiftUI

struct CategoryBudgetList: View {
    @EnvironmentObject var money: Money
    
    
    var body: some View {
        VStack{
            
            if(!money.isEmpty()){
                
                Text("Categories:")
                    .bold()
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                let sortedCategories = money.totalBudgetsByCategory
                    .filter { $0.key != "" }
                    .sorted { (category1, category2) in
                        let totalAmount1 = money.totalBudgetsByCategory[category1.key] ?? 0.0
                        let totalAmount2 = money.totalBudgetsByCategory[category2.key] ?? 0.0
                        return totalAmount1 > totalAmount2
                    }
                
                ForEach(sortedCategories, id: \.key) { category, budget in
                    
                    CategoryBudgets(category: category)
                        .environmentObject(money)
//                    ZStack(alignment: .topTrailing){
//                        NavigationLink(destination: AccountDetailView(accountName: category)){
//                            
//                        
//                        }//NavigationLink
//                    }//ZStack
                }//ForEach
            }//if
        }//VStack
        .padding()
    }//body
}//struct

#Preview {
    CategoryBudgetList()
        .environmentObject(Money())
}
