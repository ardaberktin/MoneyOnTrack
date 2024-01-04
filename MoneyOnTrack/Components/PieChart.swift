//
//  PieChart.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//

import SwiftUI
import Charts

struct PieMiddle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 60))
            //.padding(.bottom)
    }//func body content view
}//strutct PieMiddle

extension View {
    func MyPieMiddle() -> some View {
        modifier(PieMiddle())
    }//func MyPieMiddle
}// extension View

struct PieChartView: View{
    @EnvironmentObject var money: Money
    var body: some View{
        Chart {
            ForEach(Array(money.totalExpenseAmountsByCategory.filter { $0.value > 0 }.keys), id: \.self) { category in
                let totalAmount = money.totalExpenseAmountsByCategory[category] ?? 0.0
                
                SectorMark(
                    //angle: .value("amount",min(5, d.amount)),
                    //min(45, d.amount) causes unexpected behavior and the min value does not change the final placement in the chart
                    //angle: .value("amount", d.amount < 70 ? 70 : d.amount), temporary solution that works if the biggest is not that big
                    
                    angle: .value("amount",totalAmount < 70 ? 70 : totalAmount),
                    innerRadius: .ratio(0.45),
                    //outerRadius: d.amount < 50 ? 200 : 120,
                    angularInset: 2
                )//SectorMark
                .shadow(radius: 8)
                .symbolSize(70)
                .foregroundStyle(by: .value("Type", totalAmount == 0 ? "" : category))
                .symbol(by: .value("Type", totalAmount == 0 ? "" : category)) //change to category symbol later TODO
                
                .annotation(position: .overlay, alignment: .center) {
                    Text("\(totalAmount.rounded(), specifier: "%.0f")")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .scaledToFill()
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                }//annotation
                
                .cornerRadius(5)
            }// ForEach
        }// Chart
        .padding()
        .chartBackground{ proxy in
            if (money.isOverBudget() == "over spent"){
                Image(systemName: "exclamationmark.triangle.fill")
                    .MyPieMiddle()
            }else if(money.isOverBudget() == "equal"){
                Image(systemName: "exclamationmark.brakesignal")
                    .MyPieMiddle()
            }else{
                Text("$\(money.getExpenseTotal().rounded(), specifier: "%.0f")")
                    .font(.system(size: 30))
                    .frame(maxWidth: 150, alignment: .center)
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }//else
        }//chartbackground
    }//body view
}// struct view



//EMPTY Pie Chart
////////////////////////////////////////////////////////////////////////
struct EmptyData: Identifiable{
    var id = UUID().uuidString
    var amount: Int
    var category: String
}//struct EmptyData

struct EmptyPieChartView: View {
    var data = [
        EmptyData(amount: 100, category: "deneme"),
        EmptyData(amount: 100, category: "aaa"),
        EmptyData(amount: 100, category: "deneme")
    ]
    var body: some View {
        Chart {
            ForEach (data){ d in
                SectorMark(
                    angle: .value("amount", d.amount),
                    innerRadius: .ratio(0.45),
                    angularInset: 2
                )//StectorMark
                .foregroundStyle(.gray)
                .opacity(0.25)
                .cornerRadius(5)
            }// ForEach
        }// Chart
        .chartBackground{ proxy in
                Image(systemName: "creditcard")
                .MyPieMiddle()
            }//chartbackground
        }// body view
        
}//EmptyPieChartView

////////////////////////////////////////////////////////

struct PieChart: View {
    @EnvironmentObject var money: Money
    var body: some View {
            VStack {
                if(money.isEmpty()) {
                    EmptyPieChartView()
                }else{
                    PieChartView()
                }//else if empty
            }//VStack
    }//body View
}//struct PieChart

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart()
            .environmentObject(Money())
    }//preview var
}//struct PieChart_Preview


