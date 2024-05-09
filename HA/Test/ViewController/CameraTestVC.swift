//
//  CameraTestVC.swift
//  HA
//
//  Created by Porori on 5/9/24.
//

import UIKit
import AVFoundation
import Photos
import SnapKit

class CameraTestVC: UIViewController {
    
    var cameraButton = UIButton()
    var videoButton = UIButton()
    var preview = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setVideo()
        setCamera()
    }

    func setCamera() {
        view.addSubview(cameraButton)
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.backgroundColor = .blue
        
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(view.snp.trailing).inset(50)
            make.centerY.equalTo(view.snp.centerY)
        }
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    func setVideo() {
        view.addSubview(videoButton)
        videoButton.setImage(UIImage(systemName: "video"), for: .normal)
        videoButton.backgroundColor = .red
        videoButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalTo(view.snp.leading).inset(50)
            make.centerY.equalTo(view.snp.centerY)
        }
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
    }
    
    @objc func cameraButtonTapped() {
        print("카메라가 눌렸어요")
    }
    
    @objc func videoButtonTapped() {
        print("비디오가 눌렸어요")
    }
}
