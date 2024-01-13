//
//  AddAccountView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2024-01-01.
//

import SwiftUI
import SFSymbolsPicker

struct AddAccountView: View {
    @EnvironmentObject var moneyTrack: MoneyTrackData
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedAccount: String = ""
    @State private var selectedAmount: String = ""
    @State private var selectedBudget: String = ""
    @State private var selectedCategoryType: String = "Debit"
    
    // SF Symbol picker
    @State private var isPresented = false
    @State private var icon = "creditcard.circle.fill"
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Account Name", text: $selectedAccount)
                }
                
                Section {
                    
                    Picker("Category Type", selection: $selectedCategoryType) {
                        Text("Debit").tag("Debit")
                        Text("Credit").tag("Credit")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.all, 5)
                    
                    if(selectedCategoryType == "Debit"){
                        TextField("Amount", text: $selectedAmount)
                            .keyboardType(.decimalPad)
                    }else{
                        TextField("Limit", text: $selectedAmount)
                            .keyboardType(.decimalPad)
                        
                        TextField("Owed", text: $selectedAmount)
                            .keyboardType(.decimalPad)
                        
                        TextField("Balance", text: $selectedAmount)
                            .keyboardType(.decimalPad)
                        
                    }
                    

                }
                
                Section {
                    if selectedCategoryType == "Expense" {
                        TextField("Budget", text: $selectedBudget)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section {
                    HStack {
                        Text("Symbol")
                        Spacer()
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: icon)
                        }
                        .sheet(isPresented: $isPresented, content: {
                            SymbolsPicker(selection: $icon, title: "Choose your symbol", autoDismiss: true)
                        })
                    }
                }
                
                Section {
                    Button {
                        var myAmount = (selectedAmount as NSString).doubleValue
                        
                        if(selectedCategoryType == "Credit"){
                            myAmount = myAmount * -1
                        }
        
                        moneyTrack.add(
                            amount: myAmount,
                            account: selectedAccount,
                            date: Date.now,
                            symbol: icon)
                        dismiss()
                        
                    } label: {
                        Text("Save")
                    }
                }
            }
            .navigationTitle("New Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DismissAdd()
                }
            }
        }
    }
}

#Preview {
    AddAccountView()
}
