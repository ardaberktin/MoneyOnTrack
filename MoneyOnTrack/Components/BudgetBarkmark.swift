//
//  Budget Barkmark.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-22.
//

import SwiftUI
import Charts

struct BudgetBarkmark: View {
    
    var data = [
        EmptyData(amount: 100, category: "deneme"),
        EmptyData(amount: 100, category: "deneme"),
        EmptyData(amount: 100, category: "aaa"),
        EmptyData(amount: 500, category: "budget")
    ]
    
    func total() -> Int{
        var tot = 0
        data.forEach{ d in
            tot += d.amount
        }
        return tot
    }

    var body: some View {
        VStack {
            Spacer()
            Text("\(total())")
                .foregroundColor(.white)
                .padding(.bottom, 4)
        }
        .frame(maxHeight: .infinity)
        .background(Color.blue) // Customize the bar color here
    }
}

struct EmptyBudgetBarkmark: View {
    @EnvironmentObject var money: Money
    
    var data = [
        EmptyData(amount: 100, category: "deneme"),
        EmptyData(amount: 100, category: "deneme"),
        EmptyData(amount: 100, category: "aaa"),
        EmptyData(amount: 500, category: "budget")
    ]
    
    var body: some View {
            Chart{
                ForEach(data){ d in
                    BarMark(
                        x: .value(d.category, d.amount)
                    )
                }// ForEach
            }//Chart
            .frame(height: 100)
            .foregroundStyle(.gray)
            .padding()
    
    }//body view
}//struct

#Preview {
    EmptyBudgetBarkmark()
        .environmentObject(Money())
}
