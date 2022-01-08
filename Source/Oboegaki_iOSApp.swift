//
//  Oboegaki_iOSApp.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct Oboegaki_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        
        WindowGroup {
            
            let viewModel = StartupViewModel()
            
            StartupView(viewModel: viewModel).ignoresSafeArea()
            
        }
        
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        /*
         let firebaseAuth = Auth.auth()
         
         do {
             
             try firebaseAuth.signOut()
             
         } catch let signOutError as NSError {
             
             print("Error signing out: %@", signOutError)
             
         }
        
         */
         
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
      return GIDSignIn.sharedInstance.handle(url)
        
    }
}
