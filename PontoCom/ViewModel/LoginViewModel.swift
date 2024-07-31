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
        guard validateFields() else { return }
        
        isLoading = true
        errorMessage = ""
        
        fu.signUp(email: email, password: password, name: name, cpf: cpf, company: company, role: role) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    print("Signed up as \(user.email ?? "")")
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func validateFields() -> Bool {
        guard !name.isEmpty, !cpf.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos."
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "As senhas não coincidem."
            return false
        }
        
        guard validateCPF(cpf: cpf) else {
            errorMessage = "CPF inválido."
            return false
        }
        
        return true
    }
    
    func validateCPF(cpf: String) -> Bool {
        let numbers = cpf.compactMap({ Int(String($0)) })
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            let sum = slice.enumerated().map { (index, element) in
                return (slice.count + 1 - index) * element
            }.reduce(0, +)
            let digit = 11 - (sum % 11)
            return digit > 9 ? 0 : digit
        }
        
        let firstDigit = digitCalculator(numbers.prefix(9))
        let secondDigit = digitCalculator(numbers.prefix(10))
        return firstDigit == numbers[9] && secondDigit == numbers[10]
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
