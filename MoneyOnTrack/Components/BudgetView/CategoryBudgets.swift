//
//  CategoryBudgets.swift
//  MoneyOnTrack
//
//  Created by Arda Berktin on 2024-01-13.
//

import SwiftUI
import Charts

struct BudgetMarkData2: Identifiable{
    
    var id = UUID().uuidString
    var amount: Double
    var category: String
    
}//struct EmptyData
struct CategoryOverBudgetBarMark: View {
    
    let category: String

    var body: some View {
        
        let  arr1 = [
            BudgetMarkData2(amount: 100, category: "Total")
        ]
        
        Chart {
            ForEach(arr1.sorted { $0.category == "Total" || $1.category == "" }) { d in
                BarMark(
                    x: .value("amount", d.amount)
                )
                .foregroundStyle(Color.red.opacity(1.1))
            
            }//ForEach
            
            
        }//Chart
        .clipShape(Capsule())
        .frame(height: 15)
        .cornerRadius(100.0)
        .chartXAxis(.hidden)
        //.foregroundStyle(tot > maxAmount ? Color.red: Color.clear)
        .shadow(radius: 5)
        
    }//body
}//struct

struct CategoryBudgetBarMark: View {
    @EnvironmentObject var money: Money
    
    let category: String

    var body: some View {
        let tot = money.getTotalExpenseByCategory(category: category)
        let maxAmount = money.getBudget(category: category)
        let emptyArea = maxAmount - tot
        
        let  arr = [
            BudgetMarkData2(amount: tot, category: "Total"),
            BudgetMarkData2(amount: emptyArea, category: "Left"),
        ]

        Chart {
            ForEach(arr.sorted { $0.category == "Total" || $1.category == "" }) { d in
                BarMark(
                    x: .value("amount", d.amount)
                )
               // .foregroundStyle(by: .value("am", d.category))
                .foregroundStyle(d.category == "Total" ? Color.blue : Color(.systemGray5))
            
            }//ForEach
            
            
        }//Chart
        .clipShape(Capsule())
        .frame(height: 15)
        .cornerRadius(100.0)
        .chartXAxis(.hidden)
        //.foregroundStyle(tot > maxAmount ? Color.red: Color.clear)
        .shadow(radius: 5)
        
    }//body
}//struct

struct CategoryBudgets: View {
    @EnvironmentObject var money: Money
    
    let category: String
    
    var body: some View {
        VStack{
            
            VStack(alignment: .leading){
                let left = money.getBudget(category: category) - money.getTotalExpenseByCategory(category: category)
                let over = money.getTotalExpenseByCategory(category: category) - money.getBudget(category: category)
                
                HStack{
                    
                    Text(category)
                        .bold()
                        .foregroundStyle(Color.black)
                    
                    if(left > 0){
 
                        Text("$\(left, specifier: "%.2f") left")
                            .bold()
                            .foregroundColor(Color.blue) // Set the text color to the primary color
                        
                            .padding(.trailing, 2) // Add some trailing padding
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }else{
                        
                        
                        
                        Text("$\(over, specifier: "%.2f") over")
                            .bold()
                            .foregroundColor(Color.red) // Set the text color to the primary color
                        
                            .padding(.trailing, 2) // Add some trailing padding
                
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }//else
                    
                }//HStack
                
                if(left > 0){
                    CategoryBudgetBarMark(category: category)
                        .environmentObject(money)
                }else{
                    CategoryOverBudgetBarMark(category: category)
                }
                
                
                
            }//VStack
            
            HStack {
                
                let left = money.getBudget(category: category) - money.getTotalExpenseByCategory(category: category)
                
                Text("\(money.getTotalExpenseByCategory(category: category), specifier: "%.2f")")
                    .bold()
                    .foregroundColor(left > 0 ? Color.blue : Color.red) // Set the text color to the primary color
                
                    .padding(.trailing, 2) // Add some trailing padding
                
                Text("/")
                    .foregroundColor(Color.gray) // Set the text color to the secondary color
                    .padding(.horizontal, 0) // Add horizontal padding
                
                Text("\(money.getBudget(category: category), specifier: "%.2f")")
                    .foregroundColor(Color.gray) // Set the text color to the primary color
                    .padding(.leading, 0) // Add some leading padding
            }//HStack
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }//VStack
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
        )//background
    }//body
}//struct

#Preview {
    Group{
        CategoryBudgets(category: "Travel")
            .environmentObject(Money.exampleData())
    }
}
