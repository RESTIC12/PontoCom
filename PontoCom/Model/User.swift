//
//  User.swift
//  PontoCom
//
//  Created by Joel Lacerda on 07/08/24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var cpf: String
    var email: String
    var project: String
    var role: String
}
