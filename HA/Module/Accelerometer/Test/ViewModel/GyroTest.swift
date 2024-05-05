//
//  GyroTest.swift
//  HA
//
//  Created by Porori on 5/6/24.
//

import Foundation
import CoreMotion

protocol GyroTestDelegate {
    func didUpdateGyroscopeData(count: Int, gyroData: GyroscopeData)
}

class GyroTest {
    private var motionManager: CMMotionManager!
    private var gyroUpdateInterval: Double = 0.0
    private var intervalCount = 0
    var delegate: GyroTestDelegate?
    
    func startGyroUpdate() {
        motionManager = CMMotionManager()
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 1.0 / 60.0
            motionManager.startGyroUpdates(to: .main) { data, error in
                if let data = data {
                    self.intervalCount += 1
                    let gyro = data.rotationRate
                    let gyroData = GyroscopeData(roll: gyro.x,
                                                 pitch: gyro.y,
                                                 yaw: gyro.z)
                    
                    self.delegate?.didUpdateGyroscopeData(count: self.intervalCount, gyroData: gyroData)
                }
            }
        }
    }
}
