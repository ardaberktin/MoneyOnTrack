//
//  CreateCategoryView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-27.
//

import SwiftUI
import SFSymbolsPicker

struct CreateCategoryView: View {
    @EnvironmentObject var money: Money
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategoryName: String = ""
    @State private var selectedAmount: String = ""
    @State private var selectedBudget: String = ""
    @State private var selectedCategoryType: String = "Expense"
   @State private var selectedDate: Date = Date()
    //recurring options
    @State private var isRecurring: Bool = false
    @State private var recurrenceFrequency: String = "None"
    
    // SF Symbol picker
    @State private var isPresented = false
    @State private var icon = "bag.fill"
    
    var recurrenceOptions = ["None", "Daily", "Weekly", "Monthly"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category Name", text: $selectedCategoryName)
                }
                
                Section {
                    TextField("Amount", text: $selectedAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Category Type", selection: $selectedCategoryType) {
                        Text("Expense").tag("Expense")
                        Text("Income").tag("Income")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.all, 5)
                }
                
                Section {
                    if selectedCategoryType == "Expense" {
                        TextField("Budget", text: $selectedBudget)
                            .keyboardType(.decimalPad)
                    }
                }
                Section(header: Text("Date & Recurrence")) {
                                 DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                 
                                 Toggle("Recurring", isOn: $isRecurring)
                                 
                                 if isRecurring {
                                     Picker("Recurrence Frequency", selection: $recurrenceFrequency) {
                                         ForEach(recurrenceOptions, id: \.self) { option in
                                             Text(option).tag(option)
                                         }
                                     }
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
                        let myAmount = (selectedAmount as NSString).doubleValue
                        let myBudget = (selectedBudget as NSString).doubleValue
                        money.add(
                            amount: myAmount,
                            category: selectedCategoryName,
                            date: Date.now,
                            symbol: icon,
                            budget: myBudget,
                            incomeOrExpense: selectedCategoryType.lowercased()
                        )
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .navigationTitle("Category")
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
    CreateCategoryView()
        .environmentObject(Money())
}

