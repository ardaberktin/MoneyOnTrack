import SwiftUI

struct NetWorthCard: View {
    
    @EnvironmentObject var moneyTrack: MoneyTrackData
    
    var body: some View {
        VStack {
            Text("Net Worth")
                .font(.title)
                .fontWeight(.bold)
                //.foregroundColor(.blue)

                
            let netWorth = moneyTrack.getNetWorth()
            
            Text("$\(netWorth, specifier: "%.2f")")
                .font(.system(size: 36))
                .fontWeight(.bold)
                .foregroundColor(netWorth >= 0 ? .blue : .red)
                .padding(.vertical, 8)

            HStack {
                VStack {
                    Text("Assets")
                        .font(.subheadline)
                        //.foregroundColor(.blue)
                    Text("$\(moneyTrack.getTotalAssets(), specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                .padding()

                Spacer()

                VStack {
                    Text("Liabilities")
                        .font(.subheadline)
                        //.foregroundColor(.blue)
                    if(moneyTrack.getTotalLiab() != 0){
                        Text("-$\(moneyTrack.getTotalLiab() * -1, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }else{
                        Text("-$\(moneyTrack.getTotalLiab(), specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding()
    }
}

struct NetWorthCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NetWorthCard()
                .environmentObject(MoneyTrackData())
        }
    }
}


