//
//  AddDetailView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-24.
//

import SwiftUI

struct AddDetailView: View {
    @EnvironmentObject var money: Money
    @EnvironmentObject var moneytrack: MoneyTrackData
    
    @Environment(\.dismiss) var dismiss
    
    var categoryName: String
    @State private var selectedAmount: String = ""
    @State private var selectedAccount: String = ""
    
    
    var body: some View {
        
        let symbol = money.getSymbolofCategory(category: categoryName)
        
        
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: symbol)
                        Text(categoryName)
                            .bold()
                            .font(.title)
                            .padding()
                    }
                    
                    Text(String(money.getCatAmount(cat: categoryName)))
                        .bold()
                        .font(.title)
                        .padding()
                        .lineLimit(1)
                }//Section
                
                Section {
                    TextField("Input an amount", text: $selectedAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                }//Section
                
                Section {
                  Picker("Select Account", selection: $selectedAccount) {
                    ForEach(moneytrack.getAllAccountNames(), id: \.self) { accountName in
                          Text(accountName)
                      }
                    }
                }
                
                Section {
                    Button("Add Amount") {
                        var myFloat = (selectedAmount as NSString).doubleValue
                        
                        money.add(amount: myFloat, category: categoryName, date: Date.now, symbol: symbol, incomeOrExpense: "expense")
                        
                        if(money.isIncomeOrExpense(category: categoryName) == "expense"){
                            myFloat = myFloat * -1
                        }
                        
                        let accSym = moneytrack.getSymbolofAccount(account: selectedAccount)
                        
                        moneytrack.add(amount: myFloat, account: selectedAccount, date: Date.now, symbol: accSym)
                        
                        dismiss()
                    }
                }//Section
            }//Form
            .navigationTitle(categoryName)
            .navigationBarTitleDisplayMode(.inline)
        }//NavStack
    }//body
}//struct

#Preview {
    AddDetailView(categoryName: "Travel")
        .environmentObject(Money())
        .environmentObject(MoneyTrackData())
}

