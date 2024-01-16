//
//  AuthenticationManager.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-25.
//

import Foundation
import LocalAuthentication
import Firebase
import SwiftUI

//source: https://www.youtube.com/watch?v=qW1wQwHmoTI


//protocol AuthenticationDelegate: AnyObject {
//    func didLogout()
//    func didLogin()
//}

class AuthenticationManager: ObservableObject{
    //@EnvironmentObject var money: Money
    
    //Check authentication
    private(set) var context = LAContext()
    @Published private(set) var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    
    //Security
    @Published private(set) var isAuthenticated = false //biometric authentication
    //@Published private(set) var isAuthenticated = true //DANGER DANGER DANGER
    @Published private(set) var isUserLoggedIn = false //credential authentication
    
    //Error
    @Published private(set) var errorDescription: String?
    @Published var showAlert = false
    @Published var alertTitle: String?
    
    //User
    @Published var user: User?
    @Published var username: String?
    
   // weak var delegate: AuthenticationDelegate?
    
    
    
    init(){
        loadUser()
        getBiometricType()
        checkAuthentication()
        getUserInfoFromFirebase()
    }//init
    
    func loadUser() {
        user = Auth.auth().currentUser
    }//loadUser
    
    func checkAuthentication() {
        if let user = Auth.auth().currentUser {
            isUserLoggedIn = user.isEmailVerified
        } else {
            isUserLoggedIn = false
        }
    }//CheckAuthentication

    
    func getBiometricType(){
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        biometryType = context.biometryType
    }//getBiometricType
    
    func authenticateWithBiometrics() async{
        context = LAContext()
        
        if canEvaluatePolicy{
            let reason = "Log into your account"
            do{
               let success =  try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                
                if success{
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        print("isAuthenticated: ", self.isAuthenticated)
                    }
                }
            } catch{
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.showAlert = true
                    self.biometryType = .none
                }
            }
        }
    }//authenticateWithBiometrics
    
    func resendVerificationEmail() {
        guard let user = Auth.auth().currentUser else {
            print("User not found")
            return
        }

        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
            } else {
                print("Verification email sent successfully")
            }
        }
    }//resendVerificationEmail
    
    func isUserFound()-> Bool{
        guard Auth.auth().currentUser != nil else {
            print("User not found")
            return false
        }
        
            return true
    }
    
    func resetUsername(username: String){
        self.username = username
        
        addUserInfoToFirebase()
    }

//    func login(email: String, password: String){
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            if error != nil {
//                print(error?.localizedDescription ?? "")
//                self.alertTitle = "Error!"
//                self.errorDescription = "Wrong Credentials"
//                self.showAlert = true
//            } else {
//                self.isAuthenticated = true
//                self.user = result?.user
//                print("success, logged in via email and password")
//                
//            }
//        }
//        
//        //money.getFirebase()
//    }//func login
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let x = error {
                let err = x as NSError
                
                switch err.code {
                    
                case AuthErrorCode.wrongPassword.rawValue:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Wrong Password"
                    self.showAlert = true
                case AuthErrorCode.invalidEmail.rawValue:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Invalid Email"
                    self.showAlert = true
                case AuthErrorCode.userNotFound.rawValue:
                    self.alertTitle = "Error!"
                    self.errorDescription = "User Not Found"
                    self.showAlert = true
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Account Exists With Different Credentials"
                    self.showAlert = true
                case AuthErrorCode.tooManyRequests.rawValue:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Too Many Requests Have Been Made, Please try again later."
                    self.showAlert = true
                default:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Wrong Credentials"
                    self.showAlert = true
                }
    
                
            } else {
                // Check if the user's email is verified
                if let user = Auth.auth().currentUser, user.isEmailVerified {
                    self.isUserLoggedIn = true
                    self.isAuthenticated = true
                    self.user = result?.user
                    print("Success, logged in via email and password")
                } else {
                    // User's email is not verified, handle accordingly
                    print("Email not verified. Please check your email for verification.")
                    self.alertTitle = "Email not verified"
                    self.errorDescription = "Please check your email for verification."
                    self.showAlert = true
          
                                
                    
                    
                    // Optionally: Sign out the user until email is verified
                    //try? Auth.auth().signOut()
                }
            }
        }
    }

    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false
            print("should call didLogout")
            //delegate?.didLogout()  // Make sure the delegate is not nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }//logout
    
//    func signup(email: String, password: String){
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            if error != nil{
//                self.alertTitle = "Error!"
//                self.errorDescription = "Failed to create an account. Please try again."
//                self.showAlert = true
//            }else{
//                print("New Account Created")
//                self.errorDescription = "Account created! Please login again."
//                self.alertTitle = "Success!"
//                self.showAlert = true
//            }
//        }//Auth
//        
//    }//signup
    
    func signup(email: String, password: String, username: String){
        
        if(username == ""){
            self.alertTitle = "Error!"
            self.errorDescription = "Please Add a Name"
            self.showAlert = true
            
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let x = error {
                let err = x as NSError
                
                switch err.code {
                    
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Account with \(email) already exists."
                    self.showAlert = true
                default:
                    self.alertTitle = "Error!"
                    self.errorDescription = "Failed to create an account. Please try again."
                    self.showAlert = true
                }
                
                
            } else {
                print("New Account Created")
                
                //Change language for user
                Auth.auth().useAppLanguage()
                
                // Send verification email
                authResult?.user.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        print("Error sending verification email: \(error.localizedDescription)")
                    } else {
                        print("Verification email sent")
                    }
                })
                
                // Set additional properties or actions as needed
                
                self.username = username
                self.errorDescription = "Account created! Please check your email for verification."
                self.alertTitle = "Success!"
                self.showAlert = true
            }
        }
        
        addUserInfoToFirebase()
        
    }//signup
    
    func addUserInfoToFirebase(){
        guard let user = Auth.auth().currentUser else {
            return
        }

        let db = Firestore.firestore()
        let userCollection = db.collection("UserData").document(user.uid).collection("UserInfo")

        // Clear existing data in Firestore
        userCollection.getDocuments { snapshot, error in
            for document in snapshot!.documents {
                document.reference.delete()
            }

            // Save new data
                let ref1 = userCollection.document("username")
                
            ref1.setData(["username": self.username ?? "No Name"]) { error in
                    if let error = error {
                        print("Error setting document: \(error)")
                    }//if
                }//setData
        }//getdocuments
    }//addUserInfoToFirebase
    
    func getUserInfoFromFirebase(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        self.username = ""
        
        let db = Firestore.firestore()
        let userCollection = db.collection("UserData").document(user.uid).collection("UserInfo")

        userCollection.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            for document in snapshot!.documents {
                let docdata = document.data()
                
                let username = docdata["username"] as? String ?? ""
                
                self.username = username
            
            }//for
        }//getDocuments
    }//getUserInfoFromFirebase

    
}//class AuthenticationManager
