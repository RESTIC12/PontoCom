//
//  MainView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MainView: View {
    @State private var message: String = ""
    let fu = FirebaseUtils.shared

    var body: some View {
        VStack {
            Spacer()
            
            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                .font(.title)
            Text(Date.now.formatted(date: .omitted, time: .shortened))
                .font(.title)
            
            Spacer()
            
            Text(message)
            HStack {
                BotaoView(numero: "1", texto: "Entrada", simbolo: "play", cor: .verde) {
                    registrarPonto(tipo: "entrada")
                }
                BotaoView(numero: "2", texto: "Pausa", simbolo: "pause", cor: .azul) {
                    registrarPonto(tipo: "pausa")
                }
            }
            
            HStack {
                BotaoView(numero: "3", texto: "Retorno", simbolo: "arrowshape.turn.up.backward", cor: .amarelo) {
                    registrarPonto(tipo: "retorno")
                }
                BotaoView(numero: "4", texto: "Saída", simbolo: "stop", cor: .vermelho) {
                    registrarPonto(tipo: "saída")
                }
            }
        }
        .padding()
    }
    
    func registrarPonto(tipo: String) {
        let now = Date()
        let latitude: Double = 0.0 // Substitua com a latitude atual
        let longitude: Double = 0.0 // Substitua com a longitude atual
        
        fu.savePointData(tipo: tipo, horario: now, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success():
                message = "Ponto de \(tipo) registrado com sucesso!"
            case .failure(let error):
                message = "Erro ao registrar ponto: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    MainView()
}
