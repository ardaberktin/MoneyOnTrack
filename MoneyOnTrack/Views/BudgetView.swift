//
//  BudgetView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

//Budget:
//small pie chart same as home view, next to it a income outcome barchart?? (should show the balance between income and expenses determined in the budget)
//underneath, the categories amounts using a x axis bar chart for each
//


import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var moneyTrack: MoneyTrackData
    @EnvironmentObject var money: Money
    
    var body: some View {
        NavigationStack{
            ScrollView{
            
                BudgetMarkCard()
                    .environmentObject(money)
                
                
                CategoryBudgetList()
                    .environmentObject(money)
                
            }
            .navigationTitle("Budget")
            .MyToolbar()
            .refreshable {
                // Your refresh logic here
                moneyTrack.readFirebase()
                money.getFirebase()
            }
            .environmentObject(moneyTrack)

        }
    }
}

#Preview {
    BudgetView()
        .environmentObject(Money())
        .environmentObject(MoneyTrackData())
}
