import SwiftUI

struct CategoryCards: View {
    @EnvironmentObject var money: Money
    
    var categoryName: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: 
                        money.getSymbolofCategory(category: categoryName))
                    .imageScale(.large)
                    .padding(.trailing, 5)
                    .padding(.leading, 0)
                
                Text("$" + String(money.getCatAmount(cat: categoryName)))
                    .frame(maxWidth: 70, alignment: .leading)
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .truncationMode(.tail)
                   
                Spacer()
                
//                Image(systemName: "plus")
//                    .padding(.leading, 30)
                    
            }//HStack

            HStack {
                Text(categoryName)
                    .padding(.top, 1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }//HStack
            
        }//VStack
        .foregroundColor(.black) //so it doesn't become white in dark mode
        .frame(width: 150, height: 80, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 180, height: 80)
                .foregroundColor(.white)
                .shadow(color: colorScheme == .dark ? .gray : .black, radius: 5) //change the color shadow in dark mode
        )
        .overlay(
            Image(systemName: "plus")
                .padding(.leading, 120) // adjust the padding as needed
                .foregroundColor(.black) // set the color of the plus icon
                .offset(x: 5, y: -18)
        )
    }
}

#Preview {
    CategoryCards(categoryName: "Travel")
        .environmentObject(Money())
}

