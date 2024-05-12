//
//  DFDeviceMotionModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/6/24.
//

import Foundation
import CoreMotion

class DFDeviceMotionModule: MotionServiceModuleProtocol {
    var motionManager: CMMotionManager = MyCMMotionManager.shared
    
    var moduleData: Observable<ThreePointAxisProtocol> = .init(DeviceMotion(x: 0, y: 0, z: 0))
    
    func startMotionUpdate(queue: OperationQueue, interval: IntervalEnum, isShow: Bool) {
        
        if !motionManager.isDeviceMotionAvailable {
            print("DeviceMotion is not Available")
            return
        }
        motionManager.deviceMotionUpdateInterval = interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let deviceMotion = data?.rotationRate else {
                print("DeviceMotion 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            moduleData.value = DeviceMotion(x: deviceMotion.x, y: deviceMotion.y, z: deviceMotion.z)
            
            if isShow { print(moduleData.value!) }
        }
    }
    
    
    func stopMotionUpdate() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func subscribe(notificationLimitValue: Double, subscribe: @escaping () -> Void) {

        moduleData.bind { deviceMotion in
            guard let deviceMotion = deviceMotion else { return }
            if notificationLimitValue < deviceMotion.x || notificationLimitValue < deviceMotion.y || notificationLimitValue < deviceMotion.z {
                subscribe()
            }
        }
    }
}
