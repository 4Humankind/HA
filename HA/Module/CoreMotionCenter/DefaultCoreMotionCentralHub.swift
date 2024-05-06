//
//  CoreMotionCenter.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

class DefaultCoreMotionCentralHub: CoreMotionCentralHubProtocol{
    
    // MARK: - Modules
    var acclermeterModule: CoreMotionMuduleProtocol
    var gyroModule: CoreMotionMuduleProtocol
    var deviceMotionModule: CoreMotionMuduleProtocol
    var magnetmeterModule: CoreMotionMuduleProtocol
    
    init(acclermeterModule: CoreMotionMuduleProtocol = DefaultAccelerometerModule(),
         gyroModule: CoreMotionMuduleProtocol = DefaultGyroModule(),
         deviceMotionModule: CoreMotionMuduleProtocol = DefaultDeviceMotionModule(),
         magnetmeterModule: CoreMotionMuduleProtocol = DefaultMagnetometerModule()
    ) {
        self.acclermeterModule = acclermeterModule
        self.gyroModule = gyroModule
        self.deviceMotionModule = deviceMotionModule
        self.magnetmeterModule = magnetmeterModule
    }
}

extension DefaultCoreMotionCentralHub {
    func startMotionUpdate(sensor: CoreMotionSensorEnum, showConsol: Bool = false) {
        fetchModule(sensor: sensor).startUpdates(showConsol: showConsol)
    }
    
    func stopMotionUpdate(sensor: CoreMotionSensorEnum) {
        fetchModule(sensor: sensor).stopUpdates()
    }
    
    func notificationSubscribe(sensor: CoreMotionSensorEnum, onNext: @escaping () -> Void) {
        fetchModule(sensor: sensor).observedValue.bind { [weak self] axis in
            guard let self = self else { return }
            guard let axis = axis else { return }
            let absX = abs(axis.x)
            let absY = abs(axis.y)
            let absZ = abs(axis.z)
            let settingValues = self.fetchModule(sensor: sensor).settingValue
            if absX > settingValues.sensitivity.value || absY > settingValues.sensitivity.value || absZ > settingValues.sensitivity.value {
                onNext()
            }
        }
    }
    
    func setSensorSettingValue(value: CoreMotionSettingValue) {
        switch value.sensor {
        case .accelerometer:
            acclermeterModule.settingValue = value
        case .gyro:
            gyroModule.settingValue = value
        case .deviceMotion:
            deviceMotionModule.settingValue = value
        case .magnetometer:
            magnetmeterModule.settingValue = value
        }
    }
    
    private func fetchModule(sensor: CoreMotionSensorEnum) -> CoreMotionMuduleProtocol {
        switch sensor {
        case .accelerometer:
            return self.acclermeterModule
        case .gyro:
            return self.gyroModule
        case .deviceMotion:
            return self.deviceMotionModule
        case .magnetometer:
            return self.magnetmeterModule
        }
    }
}