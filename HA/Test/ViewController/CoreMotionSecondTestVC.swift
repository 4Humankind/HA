//
//  CoreMotionSecondTestVC.swift
//  HA
//
//  Created by Porori on 5/19/24.
//

import UIKit

class CoreMotionSecondTestVC: UIViewController {
    let service = DFMotionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        service.startUpdateModule(module: .accelermeter, isShow: true)
        
        service.subscribeModule(module: .accelermeter, notificationLimitValue: 5) {
            print("accelermeter Limit Over")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        service.stopUpdateModule(module: .accelermeter)
        service.stopUpdateModule(module: .deviceMotion)
        service.stopUpdateModule(module: .gyro)
    }
}
