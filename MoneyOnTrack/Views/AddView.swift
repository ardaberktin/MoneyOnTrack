//
//  AddView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

import SwiftUI

struct DismissAdd: View {
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        Button("Cancel") {
            dismiss()
        }//Button
    }//body
}//struct


struct AddView: View {
    @EnvironmentObject var money: Money
    @EnvironmentObject var moneyTrack: MoneyTrackData
    
    
    @State private var selectedAmount: String = ""
    @State private var isEditing = false
    @State private var showingAddCategoryPopOver = false
    @State private var isExpenseShowing = true
    @State private var isIncomeShowing = true
    
    
    // Sort the keys of the dictionary
    var sortedCategories: [String] {
        money.totalAmountsByCategory.keys.sorted()
    }
    
    var sortedExpenseCategories: [String] {
        money.totalExpenseAmountsByCategory.keys.sorted()
    }
    
    var sortedIncomeCategories: [String] {
        money.totalIncomeAmountsByCategory.keys.sorted()
    }
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    
                    VStack{
                        HStack{
                            Text("Expenses")
                            Text( "$" + String(money.getExpenseTotal()))
                            Button{
                                //action
                                withAnimation{
                                    isExpenseShowing.toggle()
                                }
                            }label: {
                                if(isExpenseShowing == true){
                                    Image(systemName: "arrow.down.circle")
                                }else{
                                    Image(systemName: "arrow.up.circle")
                                }
                            }
                        }//HStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding()
                        
                        if(isExpenseShowing){
                            CategoryCardsList(isEditing: $isEditing, sortedCategories: sortedExpenseCategories)
                        }//if
                    }//VStack
                    
                    VStack{
                        VStack{
                            HStack{
                                Text("Income")
                                Text( "$" + String(money.getIncomeTotal()))
                                Button{
                                    //action
                                    withAnimation{                                isIncomeShowing.toggle()
                                    }
                                }label: {
                                    if(isIncomeShowing == true){
                                        Image(systemName: "arrow.down.circle")
                                    }else{
                                        Image(systemName: "arrow.up.circle")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding()
                            
                            if(isIncomeShowing){
                                CategoryCardsList(isEditing: $isEditing, sortedCategories: sortedIncomeCategories)
                            }//if
                        }
                        
                    }//VStack
                }
                .navigationTitle(
                    Text("Add Transaction")
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        DismissAdd()
                    }//toolbaritem
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(isEditing ? "Done" : "Edit"){
                            withAnimation {
                                isEditing.toggle()
                            }//withAnimation
                        }//Button
                    }//toolbaritem
                    
                }//toolbar
                
            }//ScrollView
            
                Button {
                    showingAddCategoryPopOver = true
                } label: {
                    HStack{
                        Text("Add Category")
                            .font(.headline)
                        Image(systemName: "plus.circle.fill")
                    }//HStack
                }
                .foregroundColor(.blue)
                .font(Font.title)
                .popover(isPresented: $showingAddCategoryPopOver) {
                    CreateCategoryView()
                }//Button
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
               
        }//NavigationStack
    }// body view
   
}//struct view

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environmentObject(Money())
    }
}
