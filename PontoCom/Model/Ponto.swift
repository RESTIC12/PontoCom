//
//  Ponto.swift
//  PontoCom
//
//  Created by Joel Lacerda on 05/08/24.
//

import Foundation
import FirebaseFirestore

struct Ponto: Codable {
    var userId: String
    var tipo: String
    var horario: Date
    var latitude: Double
    var longitude: Double
    
    init(userId: String, tipo: String, horario: Date, latitude: Double, longitude: Double) {
        self.userId = userId
        self.tipo = tipo
        self.horario = horario
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(dictionary: [String: Any]) {
        guard let userId = dictionary["userId"] as? String,
              let tipo = dictionary["tipo"] as? String,
              let horario = dictionary["horario"] as? Timestamp,
              let latitude = dictionary["latitude"] as? Double,
              let longitude = dictionary["longitude"] as? Double else {
            return nil
        }
        
        self.userId = userId
        self.tipo = tipo
        self.horario = horario.dateValue()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "tipo": tipo,
            "horario": Timestamp(date: horario),
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}

