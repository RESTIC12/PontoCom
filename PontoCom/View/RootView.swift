//
//  RootView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 23/07/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var lvm = LoginViewModel()
    
    var body: some View {
        NavigationView {
            if lvm.isAuthenticated {
                if lvm.userRole == "Gestor" {
                    GestorView()
                        .environmentObject(lvm)
                        .navigationBarBackButtonHidden()
                } else if lvm.userRole == "Colaborador"{
                    MainView()
                        .environmentObject(lvm)
                        .navigationBarBackButtonHidden()
                }
            } else {
                LoginView(isAuthenticated: $lvm.isAuthenticated)
                    .environmentObject(lvm)
                    .navigationBarBackButtonHidden()
            }
        }
    }
}


#Preview {
    RootView()
}

