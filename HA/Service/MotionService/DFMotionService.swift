//
//  DFMotionService.swift
//  HA
//
//  Created by SeoJunYoung on 5/6/24.
//

import Foundation

enum MotionModuleEnum {
    case accelermeter
    case gyro
    case deviceMotion
}

class DFMotionService {
    var accelermeterModule: MotionServiceModuleProtocol
    var gyroModule: MotionServiceModuleProtocol
    var deviceMotionModule: MotionServiceModuleProtocol
    
    init(accelermeterModule: MotionServiceModuleProtocol = DFAccelermeterModule(),
         gyroModule: MotionServiceModuleProtocol = DFGyroModule(),
         deviceMotionModule: MotionServiceModuleProtocol = DFDeviceMotionModule()
    ) {
        self.accelermeterModule = accelermeterModule
        self.gyroModule = gyroModule
        self.deviceMotionModule = deviceMotionModule
    }
    
    func startUpdateModule(module: MotionModuleEnum, queue: OperationQueue = .main, interval: IntervalEnum = .hz60, isShow: Bool = false) {
        fetchModule(module: module).startMotionUpdate(queue: queue, interval: interval, isShow: isShow)
    }
    
    func stopUpdateModule(module: MotionModuleEnum) {
        fetchModule(module: module).stopMotionUpdate()
    }
    
    func subscribeModule(module: MotionModuleEnum, notificationLimitValue: Double, subscribe: @escaping () -> Void) {
        fetchModule(module: module).subscribe(notificationLimitValue: notificationLimitValue, subscribe: subscribe)
    }
    
    func fetchModule(module: MotionModuleEnum) -> MotionServiceModuleProtocol{
        switch module {
        case .accelermeter:
            return self.accelermeterModule
        case .gyro:
            return self.gyroModule
        case .deviceMotion:
            return self.deviceMotionModule
        }
    }
}
