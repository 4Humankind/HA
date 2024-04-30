//
//  DefaultAccelerometerModule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

class DefaultAccelerometerModule: CoreMotionMuduleProtocol {
    
    var manager: CMMotionManager
    
    // MARK: - ObservableProperties
    var observedValue: Observable<ThreePointAxis> = Observable(Acceleration(x: 0, y: 0, z: 0))
    
    // MARK: - SettingProperteis
    var settingValue: CoreMotionSettingValue = CoreMotionSettingValue(sensor: .accelerometer)
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    func startUpdates(showConsol: Bool) {
        manager.accelerometerUpdateInterval = settingValue.interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startAccelerometerUpdates(to: settingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let acceleration = data?.acceleration else {
                print("가속도계 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.observedValue.value = Acceleration(
                x: acceleration.x,
                y: acceleration.y,
                z: acceleration.z
            )

            if showConsol {
                print("acceleration = X: \(acceleration.x), Y: \(acceleration.y), Z: \(acceleration.z)")
            }
        }
    }
    
    func stopUpdates() {
        manager.stopAccelerometerUpdates()
    }
}
