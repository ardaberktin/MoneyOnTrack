//
//  Budget Barkmark.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-22.
//

import SwiftUI
import Charts

struct BudgetMarkData: Identifiable{
    
    var id = UUID().uuidString
    var amount: Double
    var category: String
    
}//struct EmptyData

struct BudgetBarkmarkView: View {
    @EnvironmentObject var money: Money

    var body: some View {
        let tot = money.getExpenseTotal()
        let maxAmount = money.getTotalBudget()
        let emptyArea = maxAmount - tot
        
        let  arr = [        
            BudgetMarkData(amount: tot, category: "Total"),
            BudgetMarkData(amount: emptyArea, category: "Left"),
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
        .frame(height: 100)
        .cornerRadius(100.0)
        .chartXAxis(.hidden)
        .foregroundStyle(tot > maxAmount ? Color.red: Color.clear)
        .shadow(radius: 5)
        
    }//body
}//struct

struct EmptyBudgetBarkmarkView: View {
    @EnvironmentObject var money: Money
    
    var data = [
        EmptyData(amount: 100, category: "deneme"),
    ]
    
    var body: some View {
            Chart{
                ForEach(data){ d in
                    BarMark(
                        x: .value(d.category, d.amount)
                    )
                    .foregroundStyle(Color(.systemGray5))
                    
                }// ForEach
            }//Chart
            .clipShape(Capsule())
            .frame(height: 100)
            .cornerRadius(100.0)
            .chartXAxis(.hidden)
            .shadow(radius: 5)
    
    }//body view
}//struct

struct OverBudgetBarkmarkView: View {
    @EnvironmentObject var money: Money
    
    var data = [
        EmptyData(amount: 100, category: "deneme"),
    ]
    
    var body: some View {
            Chart{
                ForEach(data){ d in
                    BarMark(
                        x: .value(d.category, d.amount)
                    )
                    .foregroundStyle(Color.red.opacity(1.1))
                    
                }// ForEach
            }//Chart
            .clipShape(Capsule())
            .frame(height: 100)
            .cornerRadius(100.0)
            .chartXAxis(.hidden)
            .shadow(radius: 5)
    
    }//body view
}//struct

struct BudgetBarkmark: View{
    @EnvironmentObject var money: Money
    
    var body: some View{
        if (money.isEmpty() || money.getTotalBudget() == 0){
            
            EmptyBudgetBarkmarkView()
                .padding()
            
        }else if(money.isOverBudget() == "over spent" || money.isOverBudget() == "equal" ){
            
            OverBudgetBarkmarkView()
                .environmentObject(money)
                .padding()
            
        }else{
            
            BudgetBarkmarkView()
                .environmentObject(money)
                .padding()
        }//else
        
        
    }//body
}//struct

extension Money {
    static func exampleData() -> Money {
        let money = Money()
        
        money.add(amount: 200, category: "groc", date: Date.now, symbol: "bag.fill", budget: 100, incomeOrExpense: "expense")
        
        money.add(amount: 200, category: "groc", date: Date.now, symbol: "bag.fill", budget: 200, incomeOrExpense: "expense")
        
        money.add(amount: 200, category: "groc", date: Date.now, symbol: "bag.fill", budget: 400, incomeOrExpense: "expense")
        
        money.add(amount: 200, category: "groc", date: Date.now, symbol: "bag.fill", budget: 400, incomeOrExpense: "expense")

        
        return money
    }
}

#Preview {
    Group {
        Text("Empty")
        BudgetBarkmark()
            .environmentObject(Money())
        
        Text("Real")
        BudgetBarkmarkView()
            .environmentObject(Money.exampleData())
        
        Text("Over Budget")
        OverBudgetBarkmarkView()
            .environmentObject(Money.exampleData())
    }
}
