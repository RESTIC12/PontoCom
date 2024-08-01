//
//  TImerViewModel.swift
//  PontoCom
//
//  Created by Joel Lacerda on 01/08/24.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var totalTime: TimeInterval = 0
    private var timer: Timer?
    private var startTime: Date?
    private var lastExitTime: Date?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $totalTime
            .sink { _ in
                // You can perform additional actions when totalTime changes, if needed.
            }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let startTime = self.startTime {
                self.totalTime += Date().timeIntervalSince(startTime)
                self.startTime = Date()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        if let startTime = startTime {
            totalTime += Date().timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        totalTime = 0
        startTime = nil
    }
    
    func checkLastExitTime() {
        if let lastExitTime = lastExitTime, Date().timeIntervalSince(lastExitTime) > 3600 {
            resetTimer()
        }
    }
    
    func setLastTimeExit(_ date: Date) {
        lastExitTime = date
    }
    
    func timeString(from interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

