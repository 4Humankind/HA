//
//  AccelerometerModule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

protocol AccelerometerModule: DefaultCoreMotionBaseMudule {
    func startAccelerometerUpdates(showConsol: Bool)
    func stopAccelerometerUpdates()
}

class DefaultAccelerometerModule: DefaultCoreMotionBaseMudule {
    
    //가속도계 기능 활성화
    func startAccelerometerUpdates(showConsol: Bool) {
        manager.accelerometerUpdateInterval = accelerometerSettingValue.interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startAccelerometerUpdates(to: accelerometerSettingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let acceleration = data?.acceleration else {
                print("가속도계 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.acceleration.value = Acceleration(
                x: acceleration.x,
                y: acceleration.y,
                z: acceleration.z
            )

            if showConsol {
                print("X축 가속도: \(acceleration.x), Y축 가속도: \(acceleration.y), Z축 가속도: \(acceleration.z)")
            }
        }
    }

    //가속도계 기능 비활성화
    func stopAccelerometerUpdates() {
        manager.stopAccelerometerUpdates()
    }
}
