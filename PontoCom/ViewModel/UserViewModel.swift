//
//  UserViewModel.swift
//  PontoCom
//
//  Created by Joel Lacerda on 07/08/24.
//

import SwiftUI
import Combine
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let firebaseUtils = FirebaseUtils.shared
    
    init() {
        fetchUsers()
    }
        
    func fetchUsers() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Usuário não autenticado"
            return
        }
        
        firebaseUtils.fetchUser(with: userId) { result in
            switch result {
            case .success(let user):
                if user.role == "Gestor" {
                    self.firebaseUtils.fetchUsers(project: user.project) { result in
                        switch result {
                        case .success(let users):
                            self.users = users
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                } else {
                    self.errorMessage = "Usuário não é um Gestor"
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
