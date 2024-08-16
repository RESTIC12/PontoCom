

//
//  JustificationViewModel.swift
//  PontoCom
//
//  Created by Rubens Parente on 12/08/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class JustificarViewModel: ObservableObject {
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var reason = ""
    @Published var notes = ""
    @Published var fileURL: URL?
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var alertType: AlertType = .success
    
    
    enum AlertType {
        case success
        case failure
    }
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func submitJustificar() {
        guard !notes.isEmpty else {
            alertMessage = "A observação é obrigatória."
            alertType = .failure
            showingAlert = true
            return
        }
        guard fileURL != nil else {
            alertMessage = "Atestado médico não anexado."
            alertType = .failure
            showingAlert = true
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            print("Usuário não autenticado")
            return
        }
        
        let id = UUID().uuidString
        let justificar = Justificar(
            id: id,
            startDate: startDate,
            endDate: endDate,
            reason: reason,
            notes: notes,
            fileURL: fileURL
        )
        // Save justificativas to Firestore
        db.collection("users").document(user.uid).collection("justificativas").document(id).setData([
            "startDate": justificar.startDate,
            "endDate": justificar.endDate,
            "reason": justificar.reason,
            "notes": justificar.notes,
            "fileURL": justificar.fileURL?.absoluteString ?? ""
        ]) { error in
            if let error = error {
                self.alertMessage = "Erro ao salvar justificativa: \(error.localizedDescription)"
                self.alertType = .failure
            } else {
                self.alertMessage = "Justificativa salva com sucesso!"
                self.alertType = .success
            }
            self.showingAlert = true
            self.clearFields()
        }
        
        // Upload file to Firebase Storage if available
        if let fileURL = fileURL {
            let fileName = fileURL.lastPathComponent
            let storageRef = storage.reference().child("justificativas/\(fileName)")
            
            storageRef.putFile(from: fileURL, metadata: nil) { metadata, error in
                if let error = error {
                    print("Erro ao fazer upload do arquivo: \(error.localizedDescription)")
                } else {
                    print("Arquivo carregado com sucesso!")
                }
            }
        }
        
       
    }
    private func clearFields() {
        startDate = Date()
        endDate = Date()
        reason = ""
        notes = ""
        fileURL = nil
    }
}

