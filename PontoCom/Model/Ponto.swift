//
//  Ponto.swift
//  PontoCom
//
//  Created by Joel Lacerda on 05/08/24.
//

import Foundation

struct Ponto: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var tipo: String
    var horario: Date
}
