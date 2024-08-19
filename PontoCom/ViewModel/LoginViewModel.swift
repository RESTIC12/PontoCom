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
    @Published var project = "Residência"
    @Published var role = "Colaborador"
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var isAuthenticated = false
    @Published var isLoginMode = true
    @Published var userRole: String?
    
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
        
        fu.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    print("Logado como \(user.email)")
                    self?.fetchUserRole(for: user)
                case .failure:
                    self?.errorMessage = "A credencial de autenticação fornecida está incorreta ou expirou"
                }
            }
        }
    }
    
    private func fetchUserRole(for user: User) {
        self.userRole = user.role
        print("User Role: \(self.userRole ?? "Unknown")")
        self.isAuthenticated = true
    }
    
//    private func fetchUserRole(for user: User) {
//        FirebaseUtils.shared.fetchCurrentUser { [weak self] result in
//            switch result {
//            case .success(let currentUser):
//                self?.userRole = currentUser.role
//                self?.isAuthenticated = true
//            case .failure(let error):
//                self?.errorMessage = "Erro ao buscar dados do usuário: \(error.localizedDescription)"
//            }
//        }
//    }
        
    func signUp() {
        guard validateFields() else { return }
        
        isLoading = true
        errorMessage = ""
        
        fu.signUp(email: email, password: password, name: name, cpf: cpf, project: project, role: role) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.fetchUserRole(for: user)
                case .failure(let error):
                    self?.errorMessage = "Erro ao buscar dados do usuário: \(error.localizedDescription)"
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
        
        guard validateEmail(email: email) else {
            errorMessage = "Email inválido."
            return false
        }
            
        guard validatePassword(password: password) else {
            errorMessage = "A senha deve ter pelo menos 8 caracteres, incluindo uma letra maiúscula, uma letra minúscula, um número e um caractere especial."
            return false
        }
        
        return true
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func validatePassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$@!%&*?])[A-Za-z\\d#$@!%&*?]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    private func validateCPF(cpf: String) -> Bool {
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
        project = "Residência"
        role = "Colaborador"
        errorMessage = ""
    }
}
