//
//  FirebaseUtils.swift
//  PontoCom
//
//  Created by Joel Lacerda on 23/07/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class FirebaseUtils {
    static let shared = FirebaseUtils()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    private init() {}
    
// MARK: - Autenticação
    
    
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login failed"])))
                return
            }
            self.fetchUser(with: user.uid) { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, cpf: String, project: String, role: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                return
            }
            
            let userData: [String: Any] = [
                "uid": user.uid,
                "name": name,
                "cpf": cpf,
                "email": email,
                "project": project,
                "role": role
            ]
            
            self.db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                self.fetchUser(with: user.uid) { result in
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
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
    
// MARK: - Usuários
    
    func fetchUser(with uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }
            do {
                let user = try document.data(as: User.self)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getUserRole(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data(), let role = data["role"] as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dados do usuário não encontrados"])))
                return
            }
            
            completion(.success(role))
        }
    }

    
    func fetchUsers(project: String, completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users")
            .whereField("role", isEqualTo: "Colaborador")
            .whereField("project", isEqualTo: project)
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let users = documents.compactMap { queryDocumentSnapshot -> User? in
                try? queryDocumentSnapshot.data(as: User.self)
            }
            completion(.success(users))
        }
    }
    
// MARK: - Pontos
    
    func savePointData(_ ponto: Ponto, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado"])))
            return
        }

        db.collection("users").document(uid).collection("pontos").addDocument(data: [
            "tipo": ponto.tipo,
            "horario": Timestamp(date: ponto.horario),
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchPoints(for userId: String, completion: @escaping (Result<[Ponto], Error>) -> Void) {
        db.collection("users").document(userId).collection("pontos").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let points = documents.compactMap { queryDocumentSnapshot -> Ponto? in
                let data = queryDocumentSnapshot.data()
                let tipo = data["tipo"] as? String ?? ""
                let horario = (data["horario"] as? Timestamp)?.dateValue() ?? Date()
                
                return Ponto(tipo: tipo, horario: horario)
            }
            completion(.success(points))
        }
    }
}
