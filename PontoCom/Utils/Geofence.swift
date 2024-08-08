//
//  Geofence.swift
//  PontoCom
//
//  Created by Joel Lacerda on 29/07/24.
//

import CoreLocation

struct Geofence {
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
    
    func contains(_ location: CLLocation) -> Bool {
        let distance = CLLocation(latitude: center.latitude, longitude: center.longitude).distance(from: location)
        return distance <= radius
    }
}

let allowedZones = [
    Geofence(center: CLLocationCoordinate2D(latitude: -3.7447296633620395, longitude: -38.53674315233693), radius: 100),
    Geofence(center: CLLocationCoordinate2D(latitude: -3.7485283360097212, longitude: -38.52773083148533), radius: 100)
    // Adicione mais zonas aqui, se necessário
]

func isLocationAllowed(_ location: CLLocation) -> Bool {
    for zone in allowedZones {
        if zone.contains(location) {
            return true
        }
    }
    return false
}
