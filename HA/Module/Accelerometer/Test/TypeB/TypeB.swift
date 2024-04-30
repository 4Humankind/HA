//
//  TypeB.swift
//  HA
//
//  Created by Porori on 4/29/24.
//

import Foundation

import CoreMotion

class TypeB_CoreMotionCenter {
    // MARK: - Properties
    
    private let manager = CMMotionManager()
    
    
    // MARK: - ObservableProperties
    private var acceleration: Observable<Acceleration> = Observable(Acceleration(x: 0, y: 0, z: 0))
    
    private var gyro: Observable<Gyro> = Observable(Gyro(x: 0, y: 0, z: 0))
    
    
    // MARK: - SettingProperteis
    private var accelerometerSettingValue = CoreMotionSettingValue(sensor: .accelerometer)
    
    private var gyroSettingValue = CoreMotionSettingValue(sensor: .gyro)
    
    private var deviceMotionSettingValue = CoreMotionSettingValue(sensor: .deviceMotion)
    
    private var magnetometerSettingValue = CoreMotionSettingValue(sensor: .magnetometer)
    
    deinit {
        for sensor in CoreMotionSensorEnum.allCases {
            stopMotionUpdate(sensor: sensor)
        }
        print(self, "deinit")
    }
}

// MARK: - CommonMethods

extension TypeB_CoreMotionCenter {
    
    func startMotionUpdate(sensor: CoreMotionSensorEnum, showConsol: Bool = false) {
        switch sensor {
        case .accelerometer:
            startAccelerometerUpdates(showConsol: showConsol)
        case .gyro:
            print("Features in development")
        case .deviceMotion:
            print("Features in development")
        case .magnetometer:
            print("Features in development")
        }
    }
    
    func stopMotionUpdate(sensor: CoreMotionSensorEnum) {
        switch sensor {
        case .accelerometer:
            stopAccelerometerUpdates()
        case .gyro:
            print("Features in development")
        case .deviceMotion:
            print("Features in development")
        case .magnetometer:
            print("Features in development")
        }
    }
    
    func notificationSubscribe(sensor: CoreMotionSensorEnum, onNext: @escaping () -> Void) {
        switch sensor {
        case .accelerometer:
            acceleration.bind { [weak self] acceleration in
                guard let self = self else { return }
                guard let acceleration = acceleration else { return }
                let absX = abs(acceleration.x)
                let absY = abs(acceleration.y)
                let absZ = abs(acceleration.z)
                let settingValues = self.fetchSettingValue(sensor: sensor)
                if absX > settingValues.notificationValue || absY > settingValues.notificationValue || absZ > settingValues.notificationValue {
                    onNext()
                }
            }
        case .gyro:
            print("Features in development")
        case .deviceMotion:
            print("Features in development")
        case .magnetometer:
            print("Features in development")
        }
    }
    
    func setSensorSettingValue(value: CoreMotionSettingValue) {
        switch value.sensor {
        case .accelerometer:
            accelerometerSettingValue = value
        case .gyro:
            gyroSettingValue = value
        case .deviceMotion:
            deviceMotionSettingValue = value
        case .magnetometer:
            magnetometerSettingValue = value
        }
    }
    
    private func fetchSettingValue(sensor: CoreMotionSensorEnum) -> CoreMotionSettingValue {
        switch sensor {
        case .accelerometer:
            return accelerometerSettingValue
        case .gyro:
            return gyroSettingValue
        case .deviceMotion:
            return deviceMotionSettingValue
        case .magnetometer:
            return magnetometerSettingValue
        }
    }
}

// MARK: - AccelerometerMethods

private extension TypeB_CoreMotionCenter {
    
    //가속도계 기능 활성화
    func startAccelerometerUpdates(showConsol: Bool) {
        manager.accelerometerUpdateInterval = accelerometerSettingValue.interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startAccelerometerUpdates(to: accelerometerSettingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let acceleration = data?.acceleration else {
                print("가속도계 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.acceleration.value = Acceleration(
                x: acceleration.x,
                y: acceleration.y,
                z: acceleration.z
            )

            if showConsol {
                print("X축 가속도: \(acceleration.x), Y축 가속도: \(acceleration.y), Z축 가속도: \(acceleration.z)")
            }
        }
    }

    //가속도계 기능 비활성화
    func stopAccelerometerUpdates() {
        manager.stopAccelerometerUpdates()
    }
}

// MARK: - GyroMethods

extension TypeB_CoreMotionCenter {
    //자이로 기능 활성화
    func startGyroUpdates(showConsol: Bool) {
        manager.gyroUpdateInterval = gyroSettingValue.interval.value
        
        // 가속도계 데이터 수집을 시작하고 업데이트를 처리하는 클로저
        manager.startGyroUpdates(to: accelerometerSettingValue.queue) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard let gyro = data else {
                print("가속도계 데이터를 가져올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.gyro.value = Gyro(
                x: gyro.rotationRate.x,
                y: gyro.rotationRate.y,
                z: gyro.rotationRate.z
            )

            if showConsol {
                print("X축 가속도: \(gyro.rotationRate.x), Y축 가속도: \(gyro.rotationRate.y), Z축 가속도: \(gyro.rotationRate.z)")
            }
        }
    }

    //가속도계 기능 비활성화
    func stopGyroUpdates() {
        manager.stopGyroUpdates()
    }
}

