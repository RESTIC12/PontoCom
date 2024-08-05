//
//  MainView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var tvm = TimerViewModel()
    @State private var message: String = ""
    @State private var isPaused: Bool = false
    @State private var isEntryCompleted: Bool = false
    let fu = FirebaseUtils.shared

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Horas trabalhadas:")
                    .font(.title2)
                
                TimerView(viewModel: tvm)
                
                Spacer()
                
                Text(message)
                
                BotaoView(texto: "Entrada", simbolo: "play", cor: .verde) {
                    registrarPonto(tipo: "entrada")
                }
                .disabled(isEntryCompleted)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Pressione este botão para bater o ponto de entrada"))
                
                HStack {
                    BotaoView(texto: isPaused ? "Retorno" : "Pausa", simbolo: isPaused ? "arrowshape.turn.up.backward" : "pause", cor: isPaused ? .amarelo : .azul) {
                        if isPaused {
                            registrarPonto(tipo: "retorno")
                        } else {
                            registrarPonto(tipo: "pausa")
                        }
                    }
                    .disabled(!isEntryCompleted)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(isPaused ? "Pressione este botão para voltar do intervalo" : "Pressione este botão para dar o intervalo"))
                    
                    BotaoView(texto: "Saída", simbolo: "stop", cor: .vermelho) {
                        registrarPonto(tipo: "saída")
                    }
                    .disabled(!isEntryCompleted)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Presione este botão para finalizar o dia"))
                    
                }
            }
            .padding()
            .onAppear {
                tvm.checkLastExitTime()
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink {
                        PerfilView()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
    }
    
    func registrarPonto(tipo: String) {
        let now = Date()
        
        guard let location = locationManager.userLocation else {
            message = "Não foi possível obter a localização."
            return
        }
        
        guard allowedZone.contains(location) else {
            message = "Você está fora da zona permitida."
            return
        }
                
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let tempoTotal: TimeInterval? = tipo == "saída" ? tvm.totalTime : nil
        
        fu.savePointData(tipo: tipo, horario: now, latitude: latitude, longitude: longitude, tempoTotal: tempoTotal) { result in
            switch result {
            case .success():
                message = "Ponto de \(tipo) registrado com sucesso!"
                if tipo == "entrada" {
                    isEntryCompleted = true
                    tvm.startTimer()
                } else if tipo == "pausa" {
                    tvm.stopTimer()
                    isPaused = true
                } else if tipo == "retorno" {
                    tvm.startTimer()
                    isPaused = false
                } else if tipo == "saída" {
                    tvm.stopTimer()
                    isEntryCompleted = false
                    tvm.setLastTimeExit(Date())
                }
            case .failure(let error):
                message = "Erro ao registrar ponto: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    MainView()
}
