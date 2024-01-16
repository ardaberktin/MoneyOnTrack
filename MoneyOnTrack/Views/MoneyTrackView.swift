import SwiftUI

struct MoneyTrackView: View {
    @EnvironmentObject var moneyTrack: MoneyTrackData
    @EnvironmentObject var money: Money

 
    @State private var isRefreshing = false
    
    private var trackStyles = ["Accounts","Transactions"]
    @State private var selectedStyle = "Accounts"

    var body: some View {
        NavigationStack {
            
            Picker("Appearance", selection: $selectedStyle) {
                ForEach(trackStyles, id: \.self) {
                    Text($0)
                }
            }//Picker
            .pickerStyle(.segmented)
            .padding(.horizontal, 100)
            
            if(selectedStyle == "Accounts"){
                AccountsView()
            }//if
            else{
                TransactionView()
            }
        }//NavStack
        .refreshable {
            // Your refresh logic here
            moneyTrack.readFirebase()
            money.getFirebase()
        }
        .environmentObject(moneyTrack)
    }
}

struct AccountsView: View{
    @State private var isAddCategoryPopoverPresented = false
    
    var body: some View{
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    NetWorthCard()
                    AccountList()
                }//VStack
                //                    .padding()
            }//ScrollView
            
            // Add Category Button
            Button(action: {
                isAddCategoryPopoverPresented.toggle()
            }) {
                HStack{
                    Text("Add Account")
                    
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }//Button
            .padding()
            .popover(isPresented: $isAddCategoryPopoverPresented) {
                AddAccountView()
            }//popover
            .frame(maxWidth: .infinity, alignment: .trailing)
            //.padding()
        }//ZStack
        .navigationTitle("Track")
        .MyToolbar()
    }//body
}//struct

struct TransactionView: View {
    var body: some View {
        ScrollView{
            Text("Hii")
        }
        .navigationTitle("Track")
        .MyToolbar()
    }
}

#Preview {
    MoneyTrackView()
        .environmentObject(MoneyTrackData())
}

