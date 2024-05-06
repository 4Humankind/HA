//
//  MyCMMotionManager.swift
//  HA
//
//  Created by SeoJunYoung on 5/2/24.
//

import Foundation

import CoreMotion

class MyCMMotionManager: CMMotionManager {
    static var shared: CMMotionManager = CMMotionManager()
    private override init() { }
}
