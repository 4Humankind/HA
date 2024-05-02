//
//  TypeA.swift
//  HA
//
//  Created by Porori on 4/29/24.
//

import UIKit
import CoreMotion

/*
 - CMMotion에는 accelerometer, gyroscope, pedometer, magnetometer, barometer이 적용
 - 2가지 데이터 타입이 제공 - 1. 가공되지 않은 raw, 2. 중력 등, 외부 값을 제외한 가공된 값 processed value.
 
 - 가공된 데이터 값에서 사용자가 기기에 적용하는 가속도, 중력의 방향을 받을수도 있음
 - CMMotionManager는 단하나만 생성할 것 - 여럿이 존재할 경우 가속도계와 자이로스코프에서 전달받는 데이터에 문제가 발생한다.
    *베터리가 더 많이 활용된다는 점 - 감지를 한다면...
 
 */

//MARK: - Acceleration
class typeATest: UIViewController {
    var motionManager = CMMotionManager()
    var timer = Timer()
    var intervalCount = 0
    
    override func viewDidLoad() {
        view.backgroundColor = .black
//        beginDetection()
        updateUsingQueue()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissDeviceUpdates()
    }
    
    // 큐를 사용했을 때의 차이점은? > queue는 특정 시간을 제공하여 주어진 시간대 보다 오래된 값들은 버릴 수 있도록 동작하는 행위 - 60초 queue의 경우, 61초 전에 생성된 값들은 버려질 수 있게 된다.
    func updateUsingQueue() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.accelerometerUpdateInterval = 5.0/60.0
            // 우리가 필요한 데이터 수치는 xArbitraryZVertical에서 받을 수 있는듯!
            self.motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] data, error in
                guard let self = self else { return }
                if let valid = data {
                    intervalCount += 1
                    let roll = valid.attitude.roll
                    let pitch = valid.attitude.pitch
                    let yaw = valid.attitude.yaw
                    
                    print("\(intervalCount)회 roll", roll)
                    print("\(intervalCount)회 pitch", pitch)
                    print("\(intervalCount)회 yaw", yaw)
                }
            }
        }
    }
    
    // just motion detection
    func beginDetection() {
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
                    // roll > roll of device, rotation of device around longitudinal axis
                    // pitch > pitch of device, 앞 뒤 방향
                    // yaw > side movements from the longitudial axis
                    intervalCount += 1
                    
                    // provided only iOS 14 and up
                    // let sensorLocation = data.sensorLocation.rawValue
                    let gravityX = data.gravity.x
                    let rotationX = data.rotationRate.x
                    let userAccelX = data.userAcceleration.x
                    let roll = data.attitude.roll
                    
                    print("\(intervalCount)interval - gravity x:", gravityX)
                    print("\(intervalCount)interval - rotationX:", rotationX)
                    print("\(intervalCount)interval - userAccelX:", userAccelX)
                    print("\(intervalCount)interval - roll:", roll)
                }
            })
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    func dismissDeviceUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
