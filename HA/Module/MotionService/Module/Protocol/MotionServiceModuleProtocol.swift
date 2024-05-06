//
//  MotionServiceMuduleProtocol.swift
//  HA
//
//  Created by SeoJunYoung on 5/6/24.
//

import Foundation
import CoreMotion

protocol MotionServiceModuleProtocol {
    
    var motionManager: CMMotionManager { get set }
    var moduleData: Observable<ThreePointAxisProtocol> { get set }
    
    func startMotionUpdate(queue: OperationQueue, interval: IntervalEnum)
    func stopMotionUpdate()
    func subscribe(notificationLimitValue: Double, subscribe: @escaping () -> Void)
}
