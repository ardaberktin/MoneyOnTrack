import SwiftUI

struct NetWorthCard: View {
    
    @EnvironmentObject var moneyTrack: MoneyTrackData
    
    var body: some View {
        VStack {
            Text("Net Worth")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

                
            let netWorth = moneyTrack.getNetWorth()
            
            if(netWorth >= 0){
                Text("$\(netWorth, specifier: "%.2f")")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(netWorth >= 0 ? .blue : .red)
                    .padding(.vertical, 8)
            }else{
                Text("-$\(netWorth * -1, specifier: "%.2f")")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(netWorth >= 0 ? .blue : .red)
                    .padding(.vertical, 8)
            }//else

            HStack {
                VStack {
                    Text("Assets")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text("$\(moneyTrack.getTotalAssets(), specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }//VStack
                .padding()

                Spacer()

                VStack {
                    Text("Liabilities")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    if(moneyTrack.getTotalLiab() != 0){
                        Text("-$\(moneyTrack.getTotalLiab() * -1, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }else{
                        Text("-$\(moneyTrack.getTotalLiab(), specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }//else
                }//VStack
                .padding()
            }//HStack
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding()
        }//Vstack
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding()
    }//body
}//struct

struct NetWorthCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NetWorthCard()
                .environmentObject(MoneyTrackData())
        }
    }
}


