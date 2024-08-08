//
//  PontosViewModel.swift
//  PontoCom
//
//  Created by Joel Lacerda on 08/08/24.
//

import Foundation
import FirebaseFirestore
import Combine

class PontosViewModel: ObservableObject {
    @Published var points: [Ponto] = []
    @Published var errorMessage = ""
    
    private let fu = FirebaseUtils.shared
    
    func fetchPoints(for userId: String) {
        fu.fetchPoints(for: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let points):
                    self.points = points
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
