//
//  AcceleratorTest.swift
//  HA
//
//  Created by Porori on 5/6/24.
//

import Foundation
import CoreMotion

protocol AcceleratorTestDelegate {
    func didUpdateAcceleratorData(count: Int, acceleratorMeter: AcceleratorData)
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
                if let data = data {
                    let acceleratometer = data.acceleration
                    let acceleratometerData = AcceleratorData(x: acceleratometer.x,
                                                              y: acceleratometer.y,
                                                              z: acceleratometer.z)
                    self.delegate?.didUpdateAcceleratorData(count: self.intervalCount,
                                                            acceleratorMeter: acceleratometerData)
                }
            }
        }
    }
}
