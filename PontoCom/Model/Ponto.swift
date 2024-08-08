//
//  Ponto.swift
//  PontoCom
//
//  Created by Joel Lacerda on 05/08/24.
//

import Foundation
import FirebaseFirestore

struct Ponto: Identifiable, Codable {
    var id: String
    var userId: String
    var tipo: String
    var horario: Date
    var latitude: Double
    var longitude: Double
}
