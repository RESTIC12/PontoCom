//
//  AppDelegate.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import Foundation
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
