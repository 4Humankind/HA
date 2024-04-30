//
//  GyroModule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

protocol GyroModule: DefaultCoreMotionBaseMudule {
    func startGyroUpdates(showConsol: Bool)
    func stopGyroUpdates()
}

class DefaultGyroModule: DefaultCoreMotionBaseMudule {
    //자이로 기능 활성화
    func startGyroUpdates(showConsol: Bool) {
        manager.gyroUpdateInterval = gyroSettingValue.interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startGyroUpdates(to: accelerometerSettingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let gyro = data else {
                print("가속도계 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.gyro.value = Gyro(
                x: gyro.rotationRate.x,
                y: gyro.rotationRate.y,
                z: gyro.rotationRate.z
            )

            if showConsol {
                print("X축 가속도: \(gyro.rotationRate.x), Y축 가속도: \(gyro.rotationRate.y), Z축 가속도: \(gyro.rotationRate.z)")
            }
        }
    }

    //가속도계 기능 비활성화
    func stopGyroUpdates() {
        manager.stopGyroUpdates()
    }
}
