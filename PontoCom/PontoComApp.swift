//
//  PontoComApp.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import Firebase

@main
struct PontoComApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            //RootView()
            SplashView(viewModel: SplashViewModel())
        }
    }
}
