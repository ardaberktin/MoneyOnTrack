//
//  MoneyData.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-21.
//

import SwiftUI
import Firebase

//Custom Data Type
class MoneyDataPoint: Identifiable, Hashable, Codable, Equatable{
    var id: String = UUID().uuidString
    var category: String
    var amount: Double
    var date: Date
    var symbol: String
    var budget: Double
    var incomeOrExpense: String

    
    init(amount: Double, category: String, id: String = UUID().uuidString, date: Date, symbol: String, budget: Double = 0.0, incomeOrExpense: String) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.symbol = symbol
        self.budget = budget
        self.incomeOrExpense = incomeOrExpense
    }//init
    
    
    //????????????????????????????????????
    
    static func == (lhs: MoneyDataPoint, rhs: MoneyDataPoint) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    //????????????????????????????????????
}

//Money Class that is responsible for keeping the amount of money saved in each category
class Money: ObservableObject, Codable  /*,AuthenticationDelegate*/{
    
    //Variables-----------
    private static let defaultCategoriesKey = "DefaultCategoriesAdded"
    
    @Published var data = [MoneyDataPoint]()
    //@Published var budget: Double
    
    //var categoryBudgets: [String: Double] = [:]
    
    var totalAmountsByCategory: [String: Double] {
        var totals: [String: Double] = [:]

        for dataPoint in data {
            let category = dataPoint.category
            let amount = dataPoint.amount

            // Accumulate the total amount for each category
            totals[category, default: 0.0] += amount
        }//for

        return totals
    }//var
    
    var totalExpenseAmountsByCategory: [String: Double] {
        var totals: [String: Double] = [:]

        for d in data {
            if(d.incomeOrExpense == "expense"){
                let category = d.category
                let amount = d.amount
                
                // Accumulate the total amount for each category
                totals[category, default: 0.0] += amount
            }//if
        }//for

        return totals
    }//var
    
    var totalIncomeAmountsByCategory: [String: Double] {
        var totals: [String: Double] = [:]

        for d in data {
            if(d.incomeOrExpense == "income"){
                let category = d.category
                let amount = d.amount
                
                // Accumulate the total amount for each category
                totals[category, default: 0.0] += amount
            }//if
        }//for

        return totals
    }//var
    
    
    let authenticationManager = AuthenticationManager()
    //--------------------
 
    enum CodingKeys: String, CodingKey {
        case data, budget/*, categoryBudgets*/
    }//enum
    

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([MoneyDataPoint].self, forKey: .data)
        //self.budget = try container.decode(Double.self, forKey: .budget)
        
        //Add default categories only on the first install
        if data.isEmpty && !UserDefaults.standard.bool(forKey: Money.defaultCategoriesKey) {
            addDefaultCategories()
            UserDefaults.standard.set(true, forKey: Money.defaultCategoriesKey)
        }
    }//required init
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        //try container.encode(budget, forKey: .budget)
    }//encode
    
    
    init() {
        //self.budget = budget

        //authenticationManager.delegate = self
                
        //Add default categories only on the first install
        if data.isEmpty && !UserDefaults.standard.bool(forKey: Money.defaultCategoriesKey) {
            addDefaultCategories()
            UserDefaults.standard.set(true, forKey: Money.defaultCategoriesKey)
        }
        
        //loadData()
        //saveUserID()
        getFirebase()
    }//init
    
//    func didLogin() {
//        print("didLogin")
//        clearData()
//        getFirebase()
//    }//didLogin
//    
//    func didLogout() {
//        print("didLogout called")
//        clearData()
//        
//    }//didLogout

    private func clearData() {
        data.removeAll()
        //budget = 0
        objectWillChange.send()
        
    }//clearData
    
    private func addDefaultCategories() {
        let defaultCategories = ["Shopping": "cart", "Food & Drinks": "fork.knife", "Travel": "airplane.departure"]
        for (category, symbol) in defaultCategories {
            let newDataPoint = MoneyDataPoint(amount: 0, category: category, date: Date(), symbol: symbol, incomeOrExpense: "expense")
            data.append(newDataPoint)
        }
        saveData()
    }
    
    func getTotalSpent() -> Double {
        var total = 0.0
        data.forEach { d in
                total += d.amount
        }//forEach
        return total
    }// getTotalNum
    
    func getExpenseTotal() -> Double{
        var total = 0.0
        
        for d in data{
            if(d.incomeOrExpense == "expense"){
                total += d.amount
            }
        }
        
        return total
        
    }//func
    
    func getIncomeTotal() -> Double{
        var total = 0.0
        
        for d in data{
            if(d.incomeOrExpense == "income"){
                total += d.amount
            }
        }
        
        return total
        
    }//func
    
    func isIncomeOrExpense(category: String) -> String{
        for d in data{
            if(d.category == category){
                return d.incomeOrExpense
            }
        }
        
        return ""
    }
    
    func getNumCategories() -> Int {
         let uniqueCategories = Set(data.map { $0.category })
         return uniqueCategories.count
     }// getNumCategories
    
    func getTotalAmountsByCategory(category: String) -> Double{
        var total = 0.0
        
        for d in data{
            if(d.category == category){
                total += d.amount
            }
        }
        
        return total
    }
    
    func getCatAmount(cat: String) -> Double{
        var total = 0.0
        data.forEach { d in
            if(d.category == cat){
                total += d.amount
            }
        }//forEach
        
        return total
    }//getCatAmount
    
    func getDateOfAmount(amount: Double) -> Date{
        
        var date: Date = Date.now
        
        for d in data {
            if(d.amount == amount){
                date = d.date
            }//if
        }//for
        
        return date
        
    }//func getDate
    
    func getSymbolofCategory(category: String) -> String{
        var sym = ""
        
        for d in data{
            
            if(d.category == category){
                sym = d.symbol
            }//if
            
        }//for
        
        return sym
        
    }
    
    //Budget-------------------------------------------------------
    func getBudget(category: String) -> Double {
        var total = 0.0
        
        for d in data{
            if(d.category == category){
                total += d.budget
            }
        }
        
        return total
    }// getbudget
    
    func setbudget(cateogry: String, budget: Double){
        
        for d in data{
            if(d.category == cateogry){
                d.budget = budget
            }//if
        }//for
        
        saveData()
    }//setbudget
    
    func removebudget(category: String){
        
        for d in data{
            if(d.category == category){
                d.budget = 0
            }//if
        }//for
        
        saveData()
    }//removebudget
    
    func isOverBudget() -> String{
        let spent = getTotalSpent()
        let budget = getTotalBudget()
        
        if(spent > budget && spent != 0.0 && budget != 0.0 ){
            return "over spent"
        }else if(spent == budget && spent != 0.0 && budget != 0.0){
            return "equal"
        }else{
            return "less spent"
        }
    }//isOverBudget
    
    func getTotalBudget() -> Double{
        var total = 0.0
        
        for d in data{
            total += d.budget
        }//for
        
        return total
    }
    //END of Budget ------------------------------------------------
    
    
    
    func editAmount(category: String, amount: Double){
        data.forEach { d in
            if(d.category == category){
                d.amount = amount
            }
        }//forEach
    }
    
    
    func add(amount: Double, category: String, date: Date, symbol:String, budget: Double? = 0.0, incomeOrExpense: String) {

        let newDataPoint = MoneyDataPoint(amount: amount, category: category, date: date, symbol: symbol, budget: budget ?? 0.0, incomeOrExpense: incomeOrExpense)
        data.append(newDataPoint)
        // Notify SwiftUI about the change
        objectWillChange.send()
        
        saveData()
        
    }// add

    
  
    
    
    func removeCategory(_ category: String) {
            data.removeAll { $0.category == category }
            saveData()
    }//removeCategory (also its amounts)
    
    
//    func resetAllAmounts(resAmount: Double = 0) {
//        data.forEach { $0.amount = resAmount }
//        
//        objectWillChange.send()
//        saveData()
//    }//resetAllAmounts
    
    func resetAllAmounts(resAmount: Double = 0) {
        data.removeAll()
        
        //objectWillChange.send()
        saveData()
    }//resetAllAmounts
    
    
    func isEmpty() -> Bool {
        let spent = getTotalSpent()
        return spent == 0
        
     }//isEmpty
    
    
 
    
    func isAllAmountsEmpty() -> Bool{
        var isAllEmpty = true
        
        for d in data{
            if(d.amount != 0){
                isAllEmpty = false
            }
        }//for
    
        return isAllEmpty
        
    }//isAllAmountsEmpty
    
    func convertDateToString(date: Date) -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        // Convert Date to String
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    
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
    }
    
    // UserDefault Actions
    func saveData() {
//        if let encodedData = try? JSONEncoder().encode(data) {
//            UserDefaults.standard.set(encodedData, forKey: userid)
//        }
//
//        UserDefaults.standard.set(budget, forKey: "budget") //save budget
        
        //saveUserID()
        addFirebase()
    }//saveData()

    func loadData() {
//        var loadEmpty = false
//
//        if let savedData = UserDefaults.standard.data(forKey: userid),
//           let decodedData = try? JSONDecoder().decode([MoneyDataPoint].self, from: savedData) {
//            self.data = decodedData
//            loadEmpty = decodedData.isEmpty //Redundant?
//        } else {
//            loadEmpty = true
//        }
//        
//        //redundant?
//        if(data.isEmpty){
//            loadEmpty = true
//            
//        }
        
        //self.budget = UserDefaults.standard.double(forKey: "budget")//load budget

        //if loadEmpty {
            getFirebase()
        //}
    }//loadData
    

    
    /////////////////////////////////////////////////////////////////////////////////////////
    // FIREBASE
    //Might be useful: https://www.youtube.com/watch?v=1HN7usMROt8&t=263s
    //Source: https://www.youtube.com/watch?v=6b2WAePdiqA&t=888s
    
    // Load data from Firestore
    func getFirebase() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        data.removeAll()
        //self.budget = 0
        
        let db = Firestore.firestore()
        
        // Get MoneyTransactions -------------------------
        let userCollection = db.collection("UserData").document(user.uid).collection("MoneyTransactions")

        userCollection.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            for document in snapshot!.documents {
                let docdata = document.data()
                
                let id = docdata["id"] as? String ?? ""
                let amount = docdata["amount"] as? Double ?? 0
                let category = docdata["category"] as? String ?? ""
                let date = docdata["date"] as? String ?? ""
                let symbol = docdata["symbol"] as? String ?? ""
                let budget = docdata["budget"] as? Double ?? 0
                let incomeOrExpense = docdata["incomeOrExpense"] as? String ?? ""
                
                if let convertedDate = self.convertStringToDate(date: date){
                    let newDataPoint = MoneyDataPoint(amount: amount, category: category, id: id, date: convertedDate , symbol: symbol, budget: budget, incomeOrExpense: incomeOrExpense)
                    print("reached here")
                    
                    if !self.data.contains(newDataPoint) {
                        self.data.append(newDataPoint)
                    }//if
                    
                }else{
                    print("Date conversion failed for document with date: " + date)
                }//else
                
            }//for
        }//get documents
        
    }//addFirebase

    
    
    func addFirebase() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let db = Firestore.firestore()
        
        //Get MoneyTransactions-------------------------
        let userCollection = db.collection("UserData").document(user.uid).collection("MoneyTransactions")

        // Clear existing data in Firestore
        userCollection.getDocuments { snapshot, error in
            for document in snapshot!.documents {
                document.reference.delete()
            }

            // Save new data
            self.data.forEach { d in
                let conDate = self.convertDateToString(date: d.date)
                let ref1 = userCollection.document(conDate)
                print(conDate)
                
                ref1.setData(["amount": d.amount, "category": d.category, "id": d.id,  "date": conDate, "symbol": d.symbol, "budget": d.budget, "incomeOrExpense": d.incomeOrExpense]) { error in
                    if let error = error {
                        print("Error setting document: \(error)")
                    }//if
                }//setData
            }//foreach
        }//getDocuments
        
    }//func addFirebase


    
    
    // END OF FIREBASE
    ////////////////////////////////////////////////////////////////////////////////////////
    
    
    
}//class
