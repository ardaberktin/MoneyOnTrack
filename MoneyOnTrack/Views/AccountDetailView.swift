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
                    }//ForEach
                }//VStack
                .padding()
                
                Button {
                    isAlertPresented = true
                } label: {
                    Text("Delete Account")
                        .padding()
                        .foregroundColor(.red) //so that the text doesn't disappear in dark mode
                        .padding(.horizontal)
                        .background(.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .alert(isPresented: $isAlertPresented) {
                    Alert(
                        title: Text("Delete Account"),
                        message: Text("Are you sure you want to delete this account?"),
                        primaryButton: .destructive(Text("Delete")) {
                            // Delete account
                            moneyTrack.removeAccount(accountName)
                            dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }

            }//ScrollView
            .navigationTitle(accountName)
        }//NavigationStack
        
        
    }//body
}

#Preview {
    AccountDetailView(accountName: "RBC Cash")
        .environmentObject(MoneyTrackData())
}
