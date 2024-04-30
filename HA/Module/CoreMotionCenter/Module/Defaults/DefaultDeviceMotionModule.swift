//
//  DefaultDeviceMotionModule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

class DefaultDeviceMotionModule: CoreMotionMuduleProtocol {
    
    var manager: CMMotionManager
    
    // MARK: - ObservableProperties
    var observedValue: Observable<ThreePointAxis> = Observable(DeviceMotion(x: 0, y: 0, z: 0))
    
    // MARK: - SettingProperteis
    var settingValue = CoreMotionSettingValue(sensor: .deviceMotion)
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    //DeviceMotion 기능 활성화
    func startUpdates(showConsol: Bool) {
        manager.gyroUpdateInterval = settingValue.interval.value
        
        // DeviceMotion 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startDeviceMotionUpdates(to: settingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let deviceMotion = data else {
                print("DeviceMotion 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.observedValue.value = DeviceMotion(
                x: deviceMotion.gravity.x,
                y: deviceMotion.gravity.y,
                z: deviceMotion.gravity.z
            )

            if showConsol {
                print("deviceMotion = X: \(deviceMotion.gravity.x), Y: \(deviceMotion.gravity.y), Z: \(deviceMotion.gravity.z)")
            }
        }
    }

    //DeviceMotion 기능 비활성화
    func stopUpdates() {
        manager.stopDeviceMotionUpdates()
    }
}
