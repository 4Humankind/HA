//
//  ViewController.swift
//  HA
//
//  Created by Porori on 4/29/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct VCData {
        var title: String
        var vc: UIViewController
    }
    
    var tableView = UITableView()
    
    var vcData: [VCData] = [
        VCData(title: "AudioRecordTest", vc: AudioRecordTestVC()),
        VCData(title: "CameraRecordTest", vc: CameraTestVC()),
        VCData(title: "CoreMotionTest", vc: CoreMotionTestVC()),
        VCData(title: "SecondCoreMotionTest", vc: CoreMotionSecondTestVC())
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = vcData[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = vcData[indexPath.row].vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
