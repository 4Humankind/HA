//
//  TypeB.swift
//  HA
//
//  Created by Porori on 4/29/24.
//

import Foundation

import CoreMotion

class Observable<T> {
    
    var value: T? {
        didSet {
            self.listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}

struct Acceleration {
    var x: Double
    var y: Double
    var z: Double
}

struct CoreMotionSettingValue {
    var sensor: CoreMotionSensorEnum
    var sensitivity: SensitivityEnum = .normal
    var interval: IntervalEnum = .hz60
    var queue: OperationQueue = .main
    
    var notificationValue: Double {
        switch sensor {
        case .accelerometer:
            switch sensitivity {
            case .sensitive:
                return 1
            case .normal:
                return 3
            case .insensitive:
                return 5
            }
        case .gyro:
            switch sensitivity {
            case .sensitive:
                return 0
            case .normal:
                return 0
            case .insensitive:
                return 0
            }
        case .deviceMotion:
            switch sensitivity {
            case .sensitive:
                return 0
            case .normal:
                return 0
            case .insensitive:
                return 0
            }
        case .magnetometer:
            switch sensitivity {
            case .sensitive:
                return 0
            case .normal:
                return 0
            case .insensitive:
                return 0
            }
        }
    }
}

enum CoreMotionSensorEnum: CaseIterable {
    case accelerometer
    case gyro
    case deviceMotion
    case magnetometer
}

enum SensitivityEnum {
    case sensitive
    case normal
    case insensitive
}

enum IntervalEnum {
    case hz30
    case hz60
    case hz120
}

extension IntervalEnum {
    var value: Double {
        switch self {
        case .hz30:
            return 1 / 30
        case .hz60:
            return 1 / 60
        case .hz120:
            return 1 / 120
        }
    }
}

class TypeB_CoreMotionCenter {
    // MARK: - Properties
    
    private let manager = CMMotionManager()
    
    
    // MARK: - ObservableValue
    private var acceleration: Observable<Acceleration> = Observable(Acceleration(x: 0, y: 0, z: 0))
    
    
    // MARK: - Setting Value
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
