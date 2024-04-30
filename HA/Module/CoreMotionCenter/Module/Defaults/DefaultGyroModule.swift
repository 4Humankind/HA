//
//  DefaultGyroModule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

class DefaultGyroModule: CoreMotionMuduleProtocol {
    
    var manager: CMMotionManager
    
    // MARK: - ObservableProperties
    var observedValue: Observable<ThreePointAxis> = Observable(Gyro(x: 0, y: 0, z: 0))
    
    // MARK: - SettingProperteis
    var settingValue = CoreMotionSettingValue(sensor: .gyro)
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    //Gyro 기능 활성화
    func startUpdates(showConsol: Bool) {
        manager.gyroUpdateInterval = settingValue.interval.value
        
        // Gyro 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startGyroUpdates(to: settingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let gyro = data else {
                print("Gyro 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.observedValue.value = Gyro(
                x: gyro.rotationRate.x,
                y: gyro.rotationRate.y,
                z: gyro.rotationRate.z
            )

            if showConsol {
                print("gyro = X: \(gyro.rotationRate.x), Y: \(gyro.rotationRate.y), Z: \(gyro.rotationRate.z)")
            }
        }
    }

    //Gyro 기능 비활성화
    func stopUpdates() {
        manager.stopGyroUpdates()
    }
}
