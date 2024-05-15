//
//  TimerModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

final class DelayRunModuleImpl: DelayRunModule {
    
    private var timer: DispatchSourceTimer?
    private var elapsedTime: Int = 0
    private var isTimerRunning = false
    
    deinit {
        stopTimer()
    }
}

extension DelayRunModuleImpl {
    
    /// 일정 시간 후에 실행되는 작업을 시작합니다.
    /// - Parameter completion: 실행될 클로저
    func startDelayedAction(delay: Int = 5, completion: @escaping () -> Void) {
        guard !isTimerRunning else { return }
        
        isTimerRunning = true
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.elapsedTime += 1
            if self.elapsedTime >= delay {
                self.stopTimer()
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        timer?.resume()
    }
    
    /// 작업을 취소 합니다.
    func cancelDelayedAction() {
        stopTimer()
    }
    
    /// 타이머를 중지합니다.
    private func stopTimer() {
        timer?.cancel()
        timer = nil
        elapsedTime = 0
        isTimerRunning = false
    }
}
