//
//  TestingVC.swift
//  HA
//
//  Created by Porori on 4/29/24.
//

import UIKit

/*
 - CMMotion에는 accelerometer, gyroscope, pedometer, magnetometer, barometer이 적용
 - 2가지 데이터 타입이 제공 - 1. 가공되지 않은 raw, 2. 중력 등, 외부 값을 제외한 가공된 값 processed value.
 
 - 가공된 데이터 값에서 사용자가 기기에 적용하는 가속도, 중력의 방향을 받을수도 있음
 - CMMotionManager는 단하나만 생성할 것 - 여럿이 존재할 경우 가속도계와 자이로스코프에서 전달받는 데이터에 문제가 발생한다.
    *베터리가 더 많이 활용된다는 점 - 감지를 한다면...
 */

//MARK: - Acceleration
// CMMotionManager를 하나만 만들어야 한다면 singleton을 사용하는게 가장 좋은가?
// 테스트 코드를 만들고 싶다면 값을 쉽게 받을 수 있는 객체로 활용하는게 좋지 않을까? > 준영이처럼 protocol를 활용하는 것도 좋은 방향일 것 같다.
// 각각 기능을 모듈별로 생성해서 구분하는건 안되나?? > 시도해보긴 했지만, 이해가 잘 안된다... - 기능 또한 실행 안됨


class TestingVC: UIViewController {
    var accelerometerViewModel = AcceleratorTest()
    var gyroscopeViewmodel = GyroTest()
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        displayGyroData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func displayAccelerometerData() {
        accelerometerViewModel.delegate = self
        accelerometerViewModel.startAccelerometerUpdate()
    }
    
    func displayGyroData() {
        gyroscopeViewmodel.delegate = self
        gyroscopeViewmodel.startGyroUpdate()
    }
}

extension TestingVC: AcceleratorTestDelegate, GyroTestDelegate, MotionManagerDelegate {
    func didUpdateAcceleratorData(count: Int, x: Double, y: Double, z: Double) {
        print("\(count)interval - x:", x)
        print("\(count)interval - y:", y)
        print("\(count)interval - z:", z)
    }
    
    func didUpdateGyroscopeData(count: Int, gyroData: GyroscopeData) {
        print("\(count)interval - roll:", gyroData.roll)
        print("\(count)interval - pitch:", gyroData.pitch)
        print("\(count)interval - yaw:", gyroData.yaw)
    }
    
    func didUpdateDeviceMotion(count: Int, roll: Double, pitch: Double, yaw: Double) {
        print("\(count)interval - roll:", roll)
        print("\(count)interval - pitch:", pitch)
        print("\(count)interval - yaw:", yaw)
    }
}
