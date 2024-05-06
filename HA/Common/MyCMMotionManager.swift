//
//  MyCMMotionManager.swift
//  HA
//
//  Created by SeoJunYoung on 5/2/24.
//

import Foundation

import CoreMotion

class MyCMMotionManager {
    static var shared: CMMotionManager = CMMotionManager()
    private init() { }
}
