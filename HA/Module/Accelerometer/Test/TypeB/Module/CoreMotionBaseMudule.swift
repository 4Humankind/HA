//
//  CoreMotionBaseMudule.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

protocol CoreMotionBaseMudule {
    var manager: CMMotionManager { get set }
    var acceleration: Observable<Acceleration> { get set }
    var gyro: Observable<Gyro> { get set }
    var accelerometerSettingValue: CoreMotionSettingValue { get set }
    var gyroSettingValue: CoreMotionSettingValue { get set }
    var deviceMotionSettingValue: CoreMotionSettingValue { get set }
    var magnetometerSettingValue: CoreMotionSettingValue { get set }
}

class DefaultCoreMotionBaseMudule: CoreMotionBaseMudule {
    
    // MARK: - Properties
    var manager: CMMotionManager = CMMotionManager()
    
    // MARK: - ObservableProperties
    var acceleration: Observable<Acceleration> = Observable(Acceleration(x: 0, y: 0, z: 0))
    
    var gyro: Observable<Gyro> = Observable(Gyro(x: 0, y: 0, z: 0))
    
    // MARK: - SettingProperteis
    var accelerometerSettingValue = CoreMotionSettingValue(sensor: .accelerometer)
    
    var gyroSettingValue = CoreMotionSettingValue(sensor: .gyro)
    
    var deviceMotionSettingValue = CoreMotionSettingValue(sensor: .deviceMotion)
    
    var magnetometerSettingValue = CoreMotionSettingValue(sensor: .magnetometer)
}
