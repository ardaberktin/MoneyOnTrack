//
//  AccountDetailView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2024-01-02.
//

import SwiftUI

struct AccountDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var moneyTrack: MoneyTrackData
    @State private var isAlertPresented = false
    @State private var isEditing = false
    
    var accountName: String
    
  
    
    // DateFormatter for formatting dates
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Balance: $" + String(moneyTrack.getAccountBalance(account: accountName)))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                
                VStack{
                    ForEach(moneyTrack.data.filter { $0.account == accountName && $0.amount != 0 }, id: \.self) { d in
                        
                        ZStack(alignment: .trailing){
                           // NavigationLink(destination: AddDetailView(categoryName: category)){
                                VStack{
                                    HStack{
                                        Image(systemName: moneyTrack.getSymbolofAccount(account: d.account))
                                            .font(.title2)
                                        
                                        VStack{
                                            Text("\(d.account): ")
                                                .bold()
                                                .font(.title3)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text(dateFormatter.string(from: d.date))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            
                                        }//VStack
                                        Spacer()
                                        
                                        if(d.amount < 0){
                                            Text("-$\(d.amount * -1, specifier: "%.1f")")
                                                .bold()
                                                .font(.title3)
                                                .foregroundColor(.red)
                                        }else{
                                            Text("$\(d.amount, specifier: "%.1f")")
                                                .bold()
                                                .font(.title3)
                                                .foregroundColor(.green)
                                        }
                                    }//HStack
                                    .padding(.all, 25)
                                    .foregroundColor(.black) //so that the text doesn't disappear in dark mode
                                    .background(.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                                    
                                }//VStack
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                            //}//NavStack
                            
                            if isEditing {
                                Button {
                                    withAnimation {
                                        //delete date of account history
                                        moneyTrack.removeDateAccount(d.date)
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(Font.title)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, Color.red)
                                        
                                }//label
                                .offset(x:10 ,y: -45)

                            }//if
                        }//ZStack
                    }//ForEach
                }//VStack
                .padding()

            }//ScrollView
            .navigationTitle(accountName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(isEditing ? "Done" : "Edit"){
                        withAnimation {
                            isEditing.toggle()
                        }//withAnimation
                    }//Button
                }//toolbaritem
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        //action
                        isAlertPresented = true
                    } label: {
                        HStack{
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                        .foregroundColor(Color.red)
                    }
                    .alert(isPresented: $isAlertPresented) {
                        Alert(
                            title: Text("Delete Account"),
                            message: Text("Are you sure you want to delete \(accountName) account?"),
                            primaryButton: .destructive(Text("Delete")) {
                                // Delete account
                                moneyTrack.removeAccount(accountName)
                                dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }

                }//toolbaritem
                
            }//toolbar
            
        }//NavigationStack
        
        
    }//body
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let moneyTrackData = MoneyTrackData()

        // Add some example data for preview
        moneyTrackData.add(amount: 100.0, account: "RBC Cash", date: Date(), symbol: "")
        moneyTrackData.add(amount: -50.0, account: "RBC Cash", date: Date().addingTimeInterval(-86400), symbol: "") // 1 day ago
        moneyTrackData.add(amount: 75.0, account: "RBC Cash", date: Date().addingTimeInterval(-172800), symbol: "") // 2 days ago

        return AccountDetailView(accountName: "RBC Cash")
            .environmentObject(moneyTrackData)
    }
}

