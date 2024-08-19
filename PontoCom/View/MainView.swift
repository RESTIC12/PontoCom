//
//  MainView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import CoreLocation
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject var lvm: LoginViewModel
    @StateObject private var lm = LocationManager()
    @StateObject private var uvm = UserViewModel()
    @StateObject private var mvm = MainViewModel()
    
    let fu = FirebaseUtils.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                ZStack {
                    VStack(spacing: 10) {
                        if !mvm.isEntryCompleted && !mvm.isExitCompleted {
                            Text("Bem-vindo(a), \(uvm.nomeUsuario)!")
                                .font(.headline)
                                .padding(.bottom, 5)
                            Text("Não esqueça de bater seu ponto.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        if let entryTime = mvm.entryTime {
                            HStack {
                                Image(systemName: "clock")
                                Text("Entrada: \(entryTime, formatter: timeFormatter)")
                                    .font(.body)
                                    .bold()
                            }
                        }
                        if let exitTime = mvm.exitTime {
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("Saída: \(exitTime, formatter: timeFormatter)")
                                    .font(.body)
                                    .bold()
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .stroke(.black, lineWidth: 2))
                }
                
                Spacer()
                
                BotaoView(texto: "Entrada", simbolo: "play", cor: .verde) {
                    mvm.registrarPonto(tipo: "entrada", locationManager: lm)
                }
                .disabled(mvm.isEntryCompleted)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Pressione este botão para bater o ponto de entrada"))
                
                HStack {
                    BotaoView(texto: mvm.isPaused ? "Retorno" : "Pausa", simbolo: mvm.isPaused ? "arrowshape.turn.up.backward" : "pause", cor: mvm.isPaused ? .amarelo : .azul) {
                        if mvm.isPaused {
                            mvm.registrarPonto(tipo: "retorno", locationManager: lm)
                        } else {
                            mvm.registrarPonto(tipo: "pausa", locationManager: lm)
                        }
                    }
                    .disabled(!mvm.isEntryCompleted)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(mvm.isPaused ? "Pressione este botão para voltar do intervalo" : "Pressione este botão para dar o intervalo"))
                    
                    BotaoView(texto: "Saída", simbolo: "stop", cor: .vermelho) {
                        mvm.registrarPonto(tipo: "saída", locationManager: lm)
                    }
                    .disabled(!mvm.isEntryCompleted)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Presione este botão para finalizar o dia"))
                    
                }
            }
            .navigationTitle("\(Date(), formatter: dateFormatter)")
            .padding()
            .alert(isPresented: $mvm.showAlert) {
                Alert(title: Text(""), message: Text(mvm.message), dismissButton: .default(Text("OK")))
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink {
                        PerfilView(userViewModel: uvm)
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

    
    #Preview {
        MainView()
            .environmentObject(LoginViewModel())
    }

