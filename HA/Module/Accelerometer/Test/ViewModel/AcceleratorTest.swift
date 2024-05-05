//
//  AcceleratorTest.swift
//  HA
//
//  Created by Porori on 5/6/24.
//

import Foundation
import CoreMotion

protocol AcceleratorTestDelegate {
    func didUpdateAcceleratorData(count: Int, x: Double, y: Double, z: Double)
}

class AcceleratorTest {
    private var motionManager: CMMotionManager!
    private var acceleratorInterval: Double = 0.0
    private var intervalCount: Int = 0
    var delegate: AcceleratorTestDelegate?
    
    func startAccelerometerUpdate() {
        motionManager = CMMotionManager()
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let validData = data {
                    let x = validData.acceleration.x
                    let y = validData.acceleration.y
                    let z = validData.acceleration.z
                    self.delegate?.didUpdateAcceleratorData(count: self.intervalCount, x: x, y: y, z: z)
                }
            }
        }
    }
}
