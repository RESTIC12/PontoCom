//
//  JustificativaFalta.swift
//  PontoCom
//
//  Created by Rubens Parente on 12/08/24.
import Foundation


struct Justificar: Identifiable {
    var id: String
    var startDate: Date
    var endDate: Date
    var reason: String
    var notes: String
    var fileURL: URL?
}
