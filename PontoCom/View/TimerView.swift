//
//  TimerView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 01/08/24.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        Text(viewModel.timeString(from: viewModel.totalTime))
            .font(.title)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(viewModel.timeString(from: viewModel.totalTime))
    }
}

#Preview {
    let vm = TimerViewModel()
    return TimerView(viewModel: vm)
        
}
