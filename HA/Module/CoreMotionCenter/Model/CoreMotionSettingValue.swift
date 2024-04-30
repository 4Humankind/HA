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
}
