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
    
    // UserDefaults key for storing selected accounts
    private let selectedAccountKey = "SelectedAccountKey_"
    
    
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
                            if !accountName.isEmpty {
                                Text(accountName + ": $" + String(moneytrack.getAccountBalance(account: accountName)))
                            }
                        }
                    }
                    .onAppear {
                        // Load the saved selected account for the category
                        selectedAccount = UserDefaults.standard.string(forKey: selectedAccountKey + categoryName) ?? ""
                    }
                    .onChange(of: selectedAccount) { _ , _ in
                        // Save the selected account for the category
                        let keyToSave = selectedAccountKey + categoryName
                        UserDefaults.standard.set(selectedAccount, forKey: keyToSave)
                    }
                }
                

                
                Section {
                    Button("Add Amount") {
                        var myFloat = (selectedAmount as NSString).doubleValue
                        
                        let inOrEx = money.isIncomeOrExpense(category: categoryName)
                        
                        money.add(amount: myFloat, category: categoryName, date: Date.now, symbol: symbol, incomeOrExpense: inOrEx)
                        
                        if(money.isIncomeOrExpense(category: categoryName) == "expense"){
                            myFloat = myFloat * -1
                        }
                        
                        let accSym = moneytrack.getSymbolofAccount(account: selectedAccount)
                        
                        moneytrack.add(amount: myFloat, account: selectedAccount, date: Date.now, symbol: accSym)
                        
                        // Cleanup UserDefaults entry if the category is deleted
                        let keyToRemove = selectedAccount + categoryName
                        if UserDefaults.standard.object(forKey: keyToRemove) != nil {
                            UserDefaults.standard.removeObject(forKey: keyToRemove)
                        }
                        
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

