//
//  DeviceMotion.swift
//  HA
//
//  Created by Porori on 5/6/24.
//

import Foundation
import CoreMotion

protocol MotionManagerDelegate: AnyObject {
    func didUpdateDeviceMotion(count: Int, roll: Double, pitch: Double, yaw: Double)
}

class DeviceMotionTest {
    private var motionManager: CMMotionManager!
    private var timer = Timer()
    private var intervalCount = 0
    private var deviceMotionInterval: TimeInterval = 0.0
    var delegate: MotionManagerDelegate?
    
    // 큐를 사용했을 때의 차이점은? > queue는 특정 시간을 제공하여 주어진 시간대 보다 오래된 값들은 버릴 수 있도록 동작하는 행위 - 60초 queue의 경우, 61초 전에 생성된 값들은 버려질 수 있게 된다.
    func updateUsingQueue() {
        motionManager = CMMotionManager()
        
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
            self.motionManager.showsDeviceMovementDisplay = true
            // 우리가 필요한 데이터 수치는 xArbitraryZVertical에서 받을 수 있는듯!
            self.motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] data, error in
                guard let self = self else { return }
                if let valid = data {
                    intervalCount += 1
                    let roll = valid.attitude.roll
                    let pitch = valid.attitude.pitch
                    let yaw = valid.attitude.yaw
                    
                    self.delegate?.didUpdateDeviceMotion(count: intervalCount, roll: roll, pitch: pitch, yaw: yaw)
                }
            }
        }
    }
    
    // just motion detection
    func startMotionUpdate() {
        motionManager = CMMotionManager()
        
        // 데이터를 받아올 수 있는 상황인지 먼저 확인
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0
            self.motionManager.showsDeviceMovementDisplay = true
            // 상황에 따라 다르게 적용할 수 있는 옵션 - xArbitraryCorrectedZVertical는 현재 위치에서의 차이점
            // 지도같은 경우 magnetic, trueNorth를 통해 자기장 위치에 따라 적용할 수 있는 옵션
            self.motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
            
            self.timer = Timer(fire: Date(), interval: 5.0, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                
                if let data = self.motionManager.deviceMotion {
                    intervalCount += 1
                    
                    // provided only iOS 14 and up
                    // let sensorLocation = data.sensorLocation.rawValue
                    let gravityX = data.gravity.x
                    let rotationX = data.rotationRate.x
                    let userAccelX = data.userAcceleration.x
                    let roll = data.attitude.roll
                }
            })
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    func dismissDeviceUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

