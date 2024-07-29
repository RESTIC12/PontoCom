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
            
            HStack {
                BotaoView(numero: "1", texto: "Entrada", simbolo: "play", cor: .verde) {
                    registrarPonto(tipo: "entrada")
                }
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(Text("Pressione o Botão um para bater o ponto de entrada"))
                
                BotaoView(numero: "2", texto: "Pausa", simbolo: "pause", cor: .azul) {
                    registrarPonto(tipo: "pausa")
                }
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(Text("Presione o Botão dois para dá o intervalo"))
            }
            
            HStack {
                BotaoView(numero: "3", texto: "Retorno", simbolo: "arrowshape.turn.up.backward", cor: .amarelo) {
                    registrarPonto(tipo: "retorno")
                }
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(Text("Presione o Botão três para voltar do intervalo"))
                
                BotaoView(numero: "4", texto: "Saída", simbolo: "stop", cor: .vermelho) {
                    registrarPonto(tipo: "saída")
                }
                .accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
                .accessibilityLabel(Text("Presione o Botão quatro para finalizar o dia"))
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
            message = "Você está fora da zona permitida para registrar o ponto."
            return
        }
                
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
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
