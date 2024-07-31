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
    @State private var message: String = ""
    @State private var isPaused: Bool = false
    @State private var isEntryCompleted: Bool = false
    let fu = FirebaseUtils.shared

    var body: some View {
        VStack {
            Spacer()
            
            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                .font(.title)
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(Date.now.formatted(date: .abbreviated, time: .omitted))
            
            Text(Date.now.formatted(date: .omitted, time: .shortened))
                .font(.title)
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(Date.now.formatted(date: .omitted, time: .shortened))
            
            Spacer()
            
            Text(message)
            
            BotaoView(texto: "Entrada", simbolo: "play", cor: .verde) {
                registrarPonto(tipo: "entrada")
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Pressione este botão para bater o ponto de entrada"))
            
            HStack {
                if !isPaused {
                    BotaoView(texto: "Pausa", simbolo: "pause", cor: .azul) {
                        registrarPonto(tipo: "pausa")
                        isPaused = true
                    }
                    .disabled(!isEntryCompleted)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Presione este botão para começar o intervalo"))
                } else {
                    BotaoView(texto: "Retorno", simbolo: "arrowshape.turn.up.backward", cor: .amarelo) {
                        registrarPonto(tipo: "retorno")
                        isPaused = false
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Presione este botão para voltar do intervalo"))
                }
                
                BotaoView(texto: "Saída", simbolo: "stop", cor: .vermelho) {
                    registrarPonto(tipo: "saída")
                }
                .disabled(!isEntryCompleted)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Presione este botão para finalizar o dia"))
                
            }
        }
        .padding()
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
        
        fu.savePointData(tipo: tipo, horario: now, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success():
                message = "Ponto de \(tipo) registrado com sucesso!"
                if tipo == "entrada" {
                    isEntryCompleted = true
                } else if tipo == "saída" {
                    isEntryCompleted = false
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
