//
//  CoreMotionCentralHubProtocol.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

protocol CoreMotionCentralHubProtocol {
    var manager: CMMotionManager { get set }
    
    var acclermeterModule: CoreMotionMuduleProtocol { get set }
    var gyroModule: CoreMotionMuduleProtocol { get set }
    var deviceMotionModule: CoreMotionMuduleProtocol { get set }
    var magnetmeterModule: CoreMotionMuduleProtocol { get set }
    
    func startMotionUpdate(sensor: CoreMotionSensorEnum, showConsol: Bool)
    func stopMotionUpdate(sensor: CoreMotionSensorEnum)
    func notificationSubscribe(sensor: CoreMotionSensorEnum, onNext: @escaping () -> Void)
    func setSensorSettingValue(value: CoreMotionSettingValue)
}
