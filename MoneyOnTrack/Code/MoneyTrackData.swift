import Foundation
import Firebase

class MoneyTrackDataPoint: Identifiable, Hashable, Codable, Equatable {
    var id: String = UUID().uuidString
    var account: String
    var amount: Double
    var date: Date
    var symbol: String

    init(amount: Double, account: String, id: String = UUID().uuidString, date: Date, symbol: String) {
        self.id = id
        self.amount = amount
        self.account = account
        self.date = date
        self.symbol = symbol
    }

    static func == (lhs: MoneyTrackDataPoint, rhs: MoneyTrackDataPoint) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class MoneyTrackData: ObservableObject, Codable {
    @Published var data = [MoneyTrackDataPoint]()

    enum CodingKeys: String, CodingKey {
        case data
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([MoneyTrackDataPoint].self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
    }

    init() {
        // Initialization code, if needed
        readFirebase()
    }

    // Other functionalities from the Money class

    // Example: Total amount by account
    var totalAmountsByAccount: [String: Double] {
        var totals: [String: Double] = [:]

        for dataPoint in data {
            let account = dataPoint.account
            let amount = dataPoint.amount

            // Accumulate the total amount for each account
            totals[account, default: 0.0] += amount
        }

        return totals
    }//func
    
    func getAccountBalance(account: String) -> Double {
        var total = 0.0
        
        for d in data{
            if(d.account == account){
                total += d.amount
            }
        }
        
        return total
    }
    
    // Additional functionalities can be added here...
    func getAllAccountNames() -> [String] {
        let accountNames = Set(data.map { $0.account })
        return Array(accountNames)
    }
    
    func getSymbolofAccount(account:String) -> String {

        
        for d in data{
            if(d.account == account){
                return d.symbol
            }
        }
        
        return ""
    }
    
    func getTotalAssets() -> Double{
        var total = 0.0
        
        for d in data{
            if(d.amount > 0 && d.account != ""){
                total += d.amount
            }
        }
        
        return total
    }
    
    func getTotalLiab() -> Double{
        var total = 0.0
        
        for d in data{
            if(d.amount < 0 && d.account != ""){
                total += d.amount
            }
        }
        
        return total
    }
    
    func getNetWorth() -> Double {
        let asset = getTotalAssets()
        let liab = getTotalLiab()
        
        return asset + liab
    }
    
    
    func isAllAmountsEmpty() -> Bool{
        
        for d in data{
            if(d.amount != 0.0){
                return false
            }
        }
        
        return true
    }
    
    
    func removeDateAccount(_ date: Date) {
            data.removeAll { $0.date == date }
            writeFirebase()
    }//removeCategory (also its amounts)
    
    // Saved
    func removeAccount(_ account: String) {
            data.removeAll { $0.account == account }
            writeFirebase()
    }//removeCategory (also its amounts)
    
    func add(amount: Double, account: String, date: Date, symbol:String) {

        let newDataPoint = MoneyTrackDataPoint(amount: amount, account: account, date: date, symbol: symbol)
        data.append(newDataPoint)
        
        // Notify SwiftUI about the change
        objectWillChange.send()
        
        writeFirebase()
        
    }// add
    
    
    //NOT WORKINGGGGGGGGGG
    func updateAccountAmount(account: String, newAmount: Double){
        
        for d in data{
            
            if(d.account == account){
                
                d.amount = newAmount
                
            }//if
        }//for
    }//func
    
    
    
    func convertDateToString(date: Date) -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        // Convert Date to String
        let dateString = dateFormatter.string(from: date)

        return dateString
    }//func
    
    func convertStringToDate(date: String) -> Date? {
        // Create String
        let dateString = date

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        // Convert String to Date
        let convertedDate = dateFormatter.date(from: dateString)
        
        return convertedDate
    }//func
    

    
    func readFirebase() {
            guard let user = Auth.auth().currentUser else {
                return
            }

            data.removeAll()

            let db = Firestore.firestore()
            let userCollection = db.collection("UserData").document(user.uid).collection("MoneyTrackData")

            userCollection.getDocuments { snapshot, error in
                guard error == nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }

                for document in snapshot!.documents {
                    let docdata = document.data()

                    // Extract data fields from the document
                    let id = docdata["id"] as? String ?? ""
                    let amount = docdata["amount"] as? Double ?? 0
                    let account = docdata["account"] as? String ?? ""
                    let date = docdata["date"] as? String ?? ""
                    let symbol = docdata["symbol"] as? String ?? ""

                    // Convert date string to Date
                    if let convertedDate = self.convertStringToDate(date: date) {
                        let newDataPoint = MoneyTrackDataPoint(amount: amount, account: account, id: id, date: convertedDate, symbol: symbol)

                        if !self.data.contains(newDataPoint) {
                            self.data.append(newDataPoint)
                        }
                    } else {
                        print("Date conversion failed for document with date: " + date)
                    }
                }
            }
        }//func

        func writeFirebase() {
            guard let user = Auth.auth().currentUser else {
                return
            }

            let db = Firestore.firestore()
            let userCollection = db.collection("UserData").document(user.uid).collection("MoneyTrackData")

            // Clear existing data in Firestore
            userCollection.getDocuments { snapshot, error in
                for document in snapshot!.documents {
                    document.reference.delete()
                }

                // Save new data
                self.data.forEach { d in
                    let conDate = self.convertDateToString(date: d.date)
                    let ref1 = userCollection.document(conDate)

                    ref1.setData(["amount": d.amount, "account": d.account, "id": d.id,  "date": conDate, "symbol": d.symbol]) { error in
                        if let error = error {
                            print("Error setting document: \(error)")
                        }
                    }
                }
            }
        }//func
}

