//
//  DFGyroModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/6/24.
//

import Foundation
import CoreMotion

class DFGyroModule: MotionServiceModuleProtocol {
    var motionManager: CMMotionManager = MyCMMotionManager.shared
    
    var moduleData: Observable<ThreePointAxisProtocol> = .init(Gyro(x: 0, y: 0, z: 0))
    
    func startMotionUpdate(queue: OperationQueue, interval: IntervalEnum, isShow: Bool) {
        
        if !motionManager.isGyroAvailable {
            print("Gyro is not Available")
            return
        }
        motionManager.gyroUpdateInterval = interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        motionManager.startGyroUpdates(to: queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let gyro = data?.rotationRate else {
                print("Gyro 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            moduleData.value = Gyro(x: gyro.x, y: gyro.y, z: gyro.z)
            
            if isShow { print(moduleData.value!) }
        }
    }
    
    
    func stopMotionUpdate() {
        motionManager.stopGyroUpdates()
    }
    
    func subscribe(notificationLimitValue: Double, subscribe: @escaping () -> Void) {

        moduleData.bind { gyro in
            guard let gyro = gyro else { return }
            if notificationLimitValue < gyro.x || notificationLimitValue < gyro.y || notificationLimitValue < gyro.z {
                subscribe()
            }
        }
    }
}
