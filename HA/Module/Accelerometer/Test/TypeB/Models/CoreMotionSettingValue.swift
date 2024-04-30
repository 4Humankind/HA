//
//  CoreMotionSettingValue.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

struct CoreMotionSettingValue {
    var sensor: CoreMotionSensorEnum
    var sensitivity: SensitivityEnum = .normal
    var interval: IntervalEnum = .hz60
    var queue: OperationQueue = .main
    
    var notificationValue: Double {
        switch sensor {
        case .accelerometer:
            switch sensitivity {
            case .sensitive:
                return 1
            case .normal:
                return 3
            case .insensitive:
                return 5
            }
        case .gyro:
            switch sensitivity {
            case .sensitive:
                return 0
            case .normal:
                return 0
            case .insensitive:
                return 0
            }
        case .deviceMotion:
            switch sensitivity {
            case .sensitive:
                return 0
            case .normal:
                return 0
            case .insensitive:
                return 0
            }
        case .magnetometer:
            switch sensitivity {
            case .sensitive:
                return 0
            case .normal:
                return 0
            case .insensitive:
                return 0
            }
        }
    }
}
