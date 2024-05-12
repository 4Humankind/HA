//
//  DFAccelermeterModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/6/24.
//

import Foundation
import CoreMotion

class DFAccelermeterModule: MotionServiceModuleProtocol {
    var motionManager: CMMotionManager = MyCMMotionManager.shared
    
    var moduleData: Observable<ThreePointAxisProtocol> = .init(Acceleration(x: 0, y: 0, z: 0))
    
    func startMotionUpdate(queue: OperationQueue, interval: IntervalEnum, isShow: Bool) {
        
        if !motionManager.isAccelerometerAvailable {
            print("Accelerometer is not Available")
            return
        }
        motionManager.accelerometerUpdateInterval = interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let acceleration = data?.acceleration else {
                print("가속도계 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            moduleData.value = Acceleration(x: acceleration.x, y: acceleration.y, z: acceleration.z)
            
            if isShow { print(moduleData.value!) }
        }
    }
    
    
    func stopMotionUpdate() {
        motionManager.stopAccelerometerUpdates()
    }
    
    func subscribe(notificationLimitValue: Double, subscribe: @escaping () -> Void) {

        moduleData.bind { acceleration in
            guard let acceleration = acceleration else { return }
            if notificationLimitValue < acceleration.x || notificationLimitValue < acceleration.y || notificationLimitValue < acceleration.z {
                subscribe()
            }
        }
    }
}
