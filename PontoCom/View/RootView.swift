//
//  RootView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 23/07/24.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel = LoginViewModel()
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationView {
            if isAuthenticated {
                MainView()
                    .navigationBarHidden(true)
            } else {
            LoginView(isAuthenticated: $isAuthenticated)
              .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    RootView()
}
