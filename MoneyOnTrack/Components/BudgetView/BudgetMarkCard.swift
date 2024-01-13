//
//  BudgetMarkCard.swift
//  MoneyOnTrack
//
//  Created by Arda Berktin on 2024-01-13.
//

import SwiftUI

struct BudgetMarkCard: View {
    @EnvironmentObject var money: Money
    
    var body: some View {
        
        VStack{
            HStack {
                Text("\(money.getExpenseTotal(), specifier: "%.2f")")
                    .bold()
                    .foregroundColor(money.isOverBudget() == "over spent" || money.isOverBudget() == "equal" ? Color.red : Color.blue) // Set the text color to the primary color
                
                    .padding(.trailing, 2) // Add some trailing padding
                
                Text("/")
                    .foregroundColor(.secondary) // Set the text color to the secondary color
                    .padding(.horizontal, 0) // Add horizontal padding
                
                Text("\(money.getTotalBudget(), specifier: "%.2f")")
                    .foregroundColor(.secondary) // Set the text color to the primary color
                    .padding(.leading, 0) // Add some leading padding
            }
            
            
            BudgetBarkmark()
                .environmentObject(money)
            
            if(money.getTotalBudget() != 0){
                
                let left = money.getTotalBudget() - money.getExpenseTotal()
                
                if(left > 0){

                    Text("$\(left, specifier: "%.2f") left")
                        .bold()
                        .foregroundColor(Color.blue) // Set the text color to the primary color
                    
                }else{
                    
                    let over = money.getExpenseTotal() - money.getTotalBudget()
                    
                    Text("$\(over, specifier: "%.2f") over")
                        .bold()
                        .foregroundColor(Color.red) // Set the text color to the primary color
                }//else


            }
        }//VStack
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding()
        
    }//body
}//struct

#Preview {
    BudgetMarkCard()
        .environmentObject(Money.exampleData())
}
