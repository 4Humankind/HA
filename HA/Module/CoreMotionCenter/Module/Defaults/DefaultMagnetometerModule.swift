//
//  DefaultMagnetometerModule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

class DefaultMagnetometerModule: CoreMotionMuduleProtocol {
    
    var manager: CMMotionManager
    
    // MARK: - ObservableProperties
    var observedValue: Observable<ThreePointAxis> = Observable(Magnetism(x: 0, y: 0, z: 0))
    
    // MARK: - SettingProperteis
    var settingValue = CoreMotionSettingValue(sensor: .magnetometer)
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    //Magnetometer 기능 활성화
    func startUpdates(showConsol: Bool) {
        manager.magnetometerUpdateInterval = settingValue.interval.value
        
        // Magnetometer 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startMagnetometerUpdates(to: settingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let magnetometer = data else {
                print("Magnetometer 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.observedValue.value = Magnetism(
                x: magnetometer.magneticField.x,
                y: magnetometer.magneticField.y,
                z: magnetometer.magneticField.z
            )

            if showConsol {
                print("magnetism = X: \(magnetometer.magneticField.x), Y: \(magnetometer.magneticField.y), Z: \(magnetometer.magneticField.z)")
            }
        }
    }

    //Magnetometer 기능 비활성화
    func stopUpdates() {
        manager.stopMagnetometerUpdates()
    }
}
