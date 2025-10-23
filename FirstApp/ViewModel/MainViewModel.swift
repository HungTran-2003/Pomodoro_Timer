//
//  MainViewModel.swift
//  FirstApp
//
//  Created by admin on 3/10/25.
//

import Foundation
internal import Combine

class MainViewModel {
    
    @Published var time = 25 * 60
    
    private var timeSchedule: Timer?
    
    func formattedTime(time: Int) -> String {
            let minutes = (time % 3600) / 60
            let secs = time % 60
            return String(format: "%02d:%02d", minutes, secs)
    }
    
    func countDown( ) {
        timeSchedule = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            self?.time -= 1
            if self?.time == 0 {
                t.invalidate()
            }
        }
    }
    
    func pause( ) {
        timeSchedule!.invalidate()
    }
    func reset( ){
        timeSchedule?.invalidate()
        timeSchedule = nil
        time = 25 * 60
    }
}
