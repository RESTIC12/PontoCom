//
//  FirebaseUtils.swift
//  PontoCom
//
//  Created by Joel Lacerda on 23/07/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseUtils {
    static let shared = FirebaseUtils()
    private let db = Firestore.firestore()
    
    private init() {}
    
// MARK: - Autenticação
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, cpf: String, company: String, role: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                // Save additional user information in Firestore
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "name": name,
                    "cpf": cpf,
                    "company": company,
                    "role": role,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
    
// MARK: - Firestore
    
    func savePointData(tipo: String, horario: Date, latitude: Double, longitude: Double, tempoTotal: TimeInterval? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado."])))
            return
        }
        
        var data: [String: Any] = [
            "userId": Auth.auth().currentUser?.uid ?? "",
            "tipo": tipo,
            "horario": Timestamp(date: horario),
            "latitude": latitude,
            "longitude": longitude
        ]
        
        if let total = tempoTotal {
            data["tempoTotal"] = total
        }
        
        db.collection("users").document(user.uid).collection("pontos").addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchPoints(completion: @escaping (Result<[Ponto], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("pontos").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var points: [Ponto] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                if let point = Ponto(dictionary: data) {
                    points.append(point)
                }
            }
            completion(.success(points))
        }
    }
}

// MARK: - Modelo Ponto

struct Ponto {
    var uid: String
    var tipo: String
    var horario: Date
    var latitude: Double
    var longitude: Double
    
    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
              let tipo = dictionary["tipo"] as? String,
              let horario = dictionary["horario"] as? Timestamp,
              let latitude = dictionary["latitude"] as? Double,
              let longitude = dictionary["longitude"] as? Double else {
            return nil
        }
        
        self.uid = uid
        self.tipo = tipo
        self.horario = horario.dateValue()
        self.latitude = latitude
        self.longitude = longitude
    }
}

