//
//  LoginView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            Group {
                Text("PontoC") + Text("o").foregroundStyle(.verde) + Text("m.")
            }
            .font(.title)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Ponto com"))
            
            Text(viewModel.errorMessage)
                .foregroundColor(.red)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("A credencial de autenticação fornecida está incorreta ou expirou"))
                .padding(.top, 10)
            
            if viewModel.isLoginMode {
                loginForm
            } else {
                signUpForm
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button {
                    viewModel.isLoginMode ? viewModel.login() : viewModel.signUp()
                } label: {
                    Text(viewModel.isLoginMode ? "Login" : "Cadastrar")
                        .padding()
                        .background(.verde)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(viewModel.isLoginMode ? "Aperte o botão para entrar" : "Aperte o botão para cadastrar"))
            }
            
            Button {
                withAnimation {
                    viewModel.toggleMode()
                }
            } label: {
                Text(viewModel.isLoginMode ? "Ainda não tenho cadastro" : "Já tenho cadastro")
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 20)
        }
        .padding()
       .onChange(of: viewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                isAuthenticated = true
            }
        }
    }
    
    private var loginForm: some View {
        VStack(spacing: 10) {
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Preencha com seu email"))
                .padding(.vertical, 10)
            
            SecureField("Senha", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Coloque sua senha"))
                .padding(.bottom, 20)
        }
    }
    
    private var signUpForm: some View {
        VStack(spacing: 10) {
            TextField("Nome", text: $viewModel.name)
                .textInputAutocapitalization(.words)
                .textFieldStyle(.roundedBorder)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Preencha com seu nome"))
            
            TextField("CPF", text: $viewModel.cpf)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Preencha com seu CPF"))
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Preencha com seu email"))
            
            SecureField("Senha", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Coloque sua senha"))
            
            SecureField("Confirme a Senha", text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Confirme sua senha"))
            
            HStack {
                Picker("Empresa", selection: $viewModel.project) {
                    Text("Residência").tag("Residência")
                    Text("CJovem").tag("CJovem")
                    Text("LDS").tag("LDS")
                }
                
                Picker("Função", selection: $viewModel.role) {
                    Text("Colaborador").tag("Colaborador")
                    Text("Gestor").tag("Gestor")
                }
            }
        }
        .padding(.bottom, 20)
    }
}


#Preview {
    LoginView(isAuthenticated: .constant(false))
}
