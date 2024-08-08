//
//  GestorView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 07/08/24.
//

import SwiftUI

struct GestorView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                List(viewModel.users) { user in
                    NavigationLink(destination: PontosView(userId: user.id ?? "")) {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    GestorView()
}
