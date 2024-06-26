//
//  CameraTestVC.swift
//  HA
//
//  Created by Porori on 5/9/24.
//

import UIKit
import AVFoundation
import SnapKit

class CameraTestVC: UIViewController {    
    private var permissionModule: PermissionModule!
    private var recordVideoModule: RecordVideoModule!
    private var captureModule: VideoCaptureModule!
    private var videoButton = UIButton()
    private var isRecording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionModule = PermissionModule()
        permissionModule.checkPermissions()
        
        captureModule = VideoCaptureModule()
        captureModule.setupCaptureSession()
        captureModule.setupPreviewLayer(to: view)
        
        recordVideoModule = RecordVideoModule(session: captureModule.captureSession)
        
        setupVideoButton()
    }
    
    private func setupVideoButton() {
        videoButton.setImage(UIImage(systemName: "video"), for: .normal)
        videoButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        
        view.addSubview(videoButton)
        videoButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalTo(view.snp.centerX).offset(50)
        }
    }
    
    // 영상이 저장되지 않는 이유는 document directory가 어플을 실행할 때마다 변경하고 있어서.
    // URL을 완전히 저장하기보다 특정 영역만 저장하면 된다 >
    @objc func toggleRecording(sender: UIButton) {
        if isRecording {
            recordVideoModule.stopRecording()
        } else {
            recordVideoModule.startRecording()
        }
        isRecording.toggle()
    }
}
