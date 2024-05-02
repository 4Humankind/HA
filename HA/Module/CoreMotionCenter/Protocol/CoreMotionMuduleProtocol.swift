//
//  CoreMotionMuduleProtocol.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

import CoreMotion

protocol CoreMotionMuduleProtocol {

    var manager: CMMotionManager { get set }
    
    var observedValue: Observable<ThreePointAxisProtocol> { get set }
    var settingValue: CoreMotionSettingValue { get set }
    
    func startUpdates(showConsol: Bool)
    func stopUpdates()
}
