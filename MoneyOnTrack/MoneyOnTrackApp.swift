//
//  Money_on_TrackApp.swift
//  Money on Track
//
//  Created by Arda Berktin on 2023-12-20.
//
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MoneyOnTrackApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var data = Money()
    @StateObject var authenticationManager = AuthenticationManager()
    @StateObject var moneyTrack = MoneyTrackData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
                .environmentObject(authenticationManager)
                .environmentObject(moneyTrack)
        }
    }
}

