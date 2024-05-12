//
//  CoreMotionTestVC.swift
//  HA
//
//  Created by SeoJunYoung on 5/12/24.
//

import UIKit

class CoreMotionTestVC: UIViewController {
    let service = DFMotionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        service.startUpdateModule(module: .accelermeter, isShow: true)
        service.startUpdateModule(module: .deviceMotion, isShow: true)
        service.startUpdateModule(module: .gyro, isShow: true)
        
        service.subscribeModule(module: .accelermeter, notificationLimitValue: 5) {
            print("accelermeter Limit Over")
        }
        
        service.subscribeModule(module: .deviceMotion, notificationLimitValue: 5) {
            print("deviceMotion Limit Over")
        }
        
        service.subscribeModule(module: .gyro, notificationLimitValue: 5) {
            print("gyro Limit Over")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        service.stopUpdateModule(module: .accelermeter)
        service.stopUpdateModule(module: .deviceMotion)
        service.stopUpdateModule(module: .gyro)
    }
}
