//
//  HomeView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var money: Money
    @EnvironmentObject var moneyTrack: MoneyTrackData
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack{
                        Text("Monthly Spendings: $" + String(money.getExpenseTotal()))
                            .frame(maxWidth: .infinity,maxHeight:30, alignment: .leading)
                            .padding()
                            .font(.title.bold())
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        Text("Budget: $" + String(money.getTotalBudget()))
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        
                        PieChart()
                            .frame( minHeight: 400,maxHeight: .infinity, alignment: .center)
                        
                    }//VStack
                    
                    CategoryTransacList()
                        .environmentObject(money)
                    
                }//ScrollView
                .refreshable {
                    // Your refresh logic here
                    money.getFirebase()
                    moneyTrack.readFirebase()
                }
                .environmentObject(money)
            }
            
            .navigationTitle(
                    Text(Date().formatted(.dateTime.month(.wide).day()))
            )
            .MyToolbar()
        }//NavigationStack
        
    }// body View
    
}//struct View

struct HomeView_Previews: PreviewProvider {
 static var previews: some View {
     HomeView()
         .environmentObject(Money())
 }
}//struct
