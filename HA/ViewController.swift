//
//  ViewController.swift
//  HA
//
//  Created by Porori on 4/29/24.
//

import UIKit

class ViewController: UIViewController {

    let center = TypeB_CoreMotionCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        center.startMotionUpdate(sensor: .gyro)
    }
}
