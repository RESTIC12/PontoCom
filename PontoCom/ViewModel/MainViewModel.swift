//
//  MainViewModel.swift
//  PontoCom
//
//  Created by Joel Lacerda on 15/08/24.
//

import SwiftUI
import CoreLocation
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var showAlert = false
    @Published var isPaused: Bool = false
    @Published var isEntryCompleted: Bool = false
    @Published var isExitCompleted: Bool = false
    @Published var entryTime: Date? {
        didSet { saveEntryTime() }
    }
    @Published var exitTime: Date? {
        didSet { saveExitTime() }
    }
    let fu = FirebaseUtils.shared

    init() {
        loadState()
    }

    private func saveEntryTime() {
        if let entryTime = entryTime {
            UserDefaults.standard.set(entryTime, forKey: "entryTime")
        }
    }

    private func saveExitTime() {
        if let exitTime = exitTime {
            UserDefaults.standard.set(exitTime, forKey: "exitTime")
        }
    }
    
    private func checkIfNewDay() {
        guard let lastEntryTime = entryTime else { return }
        if !Calendar.current.isDateInToday(lastEntryTime) {
            resetDay()
        }
    }

    private func resetDay() {
        isEntryCompleted = false
        isExitCompleted = false
        entryTime = nil
        exitTime = nil
        saveState()
    }
    
    func registrarPonto(tipo: String, locationManager: LocationManager) {
        let now = Date()
        
        guard let location = locationManager.userLocation else {
            message = "Não foi possível obter a localização."
            return
        }
        
        guard isLocationAllowed(location) else {
            message = "Você está fora da zona permitida."
            return
        }
        
        guard Auth.auth().currentUser != nil else {
            message = "Usuário não autenticado"
            return
        }
        
        // Criar uma instância de Ponto
        let ponto = Ponto(tipo: tipo, horario: now)
        
        fu.savePointData(ponto) { result in
            switch result {
            case .success():
                self.message = "Ponto de \(tipo) registrado com sucesso!"
                self.showAlert = true
                self.updateState(for: tipo, at: now)
            case .failure(let error):
                self.message = "Erro ao registrar ponto: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    private func updateState(for tipo: String, at date: Date) {
        switch tipo {
        case "entrada":
            isEntryCompleted = true
            entryTime = date
        case "pausa":
            isPaused = true
        case "retorno":
            isPaused = false
        case "saída":
            isExitCompleted = true
            exitTime = date
        default:
            break
        }
        saveState()
    }
    
    private func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(isEntryCompleted, forKey: "isEntryCompleted")
        defaults.set(isPaused, forKey: "isPaused")
        defaults.set(isExitCompleted, forKey: "isExitCompleted")
        if let entryTime = entryTime {
            defaults.set(entryTime, forKey: "entryTime")
        }
        if let exitTime = exitTime {
            defaults.set(exitTime, forKey: "exitTime")
        }
    }
    
    private func loadState() {
        let defaults = UserDefaults.standard
        isEntryCompleted = defaults.bool(forKey: "isEntryCompleted")
        isPaused = defaults.bool(forKey: "isPaused")
        isExitCompleted = defaults.bool(forKey: "isExitCompleted")
        entryTime = defaults.object(forKey: "entryTime") as? Date
        exitTime = defaults.object(forKey: "exitTime") as? Date
    }
}

