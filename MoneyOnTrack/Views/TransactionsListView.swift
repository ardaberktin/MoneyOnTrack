//
//  TransactionsListView.swift
//  MoneyOnTrack
//
//  Created by Arda Berktin on 2024-10-06.
//

import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var money: Money
    
    // DateFormatter for formatting dates
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // You can remove or change this to show the overall budget if needed
                    Text("Total Spendings: $" + String(money.getExpenseTotal()))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                VStack {
                    // Iterate over all transactions, no category filter
                    ForEach(money.data.filter { $0.amount > 0 }, id: \.self) { d in
                        
                        VStack {
                            HStack {
                                Image(systemName: money.getSymbolofCategory(category: d.category))
                                    .font(.title2)
                                
                                VStack {
                                    Text("\(d.category): ")
                                        .bold()
                                        .font(.title3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(dateFormatter.string(from: d.date))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Spacer()
                                
                                Text("-$\(d.amount, specifier: "%.1f")")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(.red)
                            }
                            .padding(.all, 25)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            .navigationTitle("All Transactions") // Update title to reflect no specific category
        }
    }
}

#Preview {
    TransactionsListView()
        .environmentObject(Money())
}
