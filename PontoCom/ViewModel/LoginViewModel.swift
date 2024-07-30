//
//  LoginViewModel.swift
//  PontoCom
//
//  Created by Joel Lacerda on 30/07/24.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var cpf = ""
    @Published var confirmPassword = ""
    @Published var company = "IREDE"
    @Published var role = "Colaborador"
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var isAuthenticated = false
    @Published var isLoginMode = true
    
    private let fu = FirebaseUtils.shared
    
    func toggleMode() {
        isLoginMode.toggle()
        clearFields()
    }
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor, insira email e senha."
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        fu.login(email: email, password: password) { result in
            self.isLoading = false
            switch result {
            case .success(let user):
                print("Logged in as \(user.email ?? "")")
                self.isAuthenticated = true
            case .failure:
                self.errorMessage = "A credencial de autenticação fornecida está incorreta ou expirou"
            }
        }
    }
        
    func signUp() {
        guard !name.isEmpty, !cpf.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !company.isEmpty, !role.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "As senhas não coincidem."
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        fu.signUp(email: email, password: password, name: name, cpf: cpf, company: company, role: role) { result in
            self.isLoading = false
            switch result {
            case .success(let user):
                print("Signed up as \(user.email ?? "")")
                self.isAuthenticated = true
            case .failure:
                self.errorMessage = "Erro ao criar conta. Tente novamente."
            }
        }
    }
    
    private func clearFields() {
        name = ""
        cpf = ""
        email = ""
        password = ""
        confirmPassword = ""
        company = "IREDE"
        role = "Colaborador"
        errorMessage = ""
    }
}
