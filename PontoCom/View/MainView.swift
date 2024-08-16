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
                
                // Data e Horários
                if let entryTime = mvm.entryTime {
                    Text("Entrada: \(entryTime, formatter: timeFormatter)")
                }
                if let exitTime = mvm.exitTime {
                    Text("Saída: \(exitTime, formatter: timeFormatter)")
                }
                
                Spacer()
                
                Text(mvm.message)
                
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

