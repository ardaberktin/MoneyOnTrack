//
//  CategoryTransacList.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-28.
//

import SwiftUI

struct AccountList: View {
    @EnvironmentObject var moneyTrack: MoneyTrackData
    
    var body: some View {
        
        VStack{
            
            if(!moneyTrack.isAllAmountsEmpty()){
                Text("Your Acccounts:")
                    .bold()
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                let sortedCategories = moneyTrack.totalAmountsByAccount
                    .filter { $0.key != "" }
                    .sorted { (category1, category2) in
                        let totalAmount1 = moneyTrack.totalAmountsByAccount[category1.key] ?? 0.0
                        let totalAmount2 = moneyTrack.totalAmountsByAccount[category2.key] ?? 0.0
                        return totalAmount1 > totalAmount2
                    }
                
                ForEach(sortedCategories, id: \.key) { category, totalAmount in
                        ZStack(alignment: .topTrailing){
                            NavigationLink(destination: AccountDetailView(accountName: category)){
                                
                                VStack{
                                    HStack{
                                        Image(systemName: moneyTrack.getSymbolofAccount(account: category))
                                            .font(.title2)
                                        
                                        VStack{
                                            Text("\(category): ")
                                                .bold()
                                                .font(.title3)
                                            
                                            //Text(d.date)
                                            
                                        }//VStack
                                        Spacer()
                                        
                                        if(totalAmount < 0){
                                            Text("-$\(totalAmount * -1, specifier: "%.1f")")
                                                .bold()
                                                .font(.title3)
                                                .foregroundColor(.red)
                                        }else{
                                            Text("$\(totalAmount, specifier: "%.1f")")
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
                            }//NavigationLink
                        }//ZStack
                }//ForEach
            }//if
        }//VStack
        .padding()
        
      
        
        
    }//body
}//struct

#Preview {
    AccountList()
        .environmentObject(MoneyTrackData())
}

