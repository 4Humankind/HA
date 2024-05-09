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


enum SessionResult {
    case success
    case notAllowed
    case failed
}

class CameraTestVC: UIViewController {
    
    // 촬영할 화면을 보여주는 screen은 preview
    // 해당 preview에 라이브로 실행 중인 카메라의 모습을 보여주는 것은 session을 갈아끼우는 것으로 보여진다.

    var videoButton = UIButton()
    var cameraButton = UIButton()
    // 그렇다면 이 preview는 왜 있는건가?
    var preview = CameraPreviewService()
    
    // MARK: - Session
    // session 안에 사진, 영상, preview를 한번에 제공한다.
    var session = AVCaptureSession()
    // 정확하게 어떤 역할이지?
    let sessionQueue = DispatchQueue(label: "session Queue")
    var isGranted: SessionResult = .notAllowed
    private var isRunning: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // UI는 이후에 설정될 수 있도록 바꿔야 한다. sessions이 생성된 이후 시점
        setVideo()
        setCamera()
    }
    
    func configure() {
        view.backgroundColor = .white
        
//        cameraButton.isEnabled = false
//        videoButton.isEnabled = false
        
        // setting up the initial preview
//        preview.session = session
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("허용됐습니다.")
            isGranted = .success
            session.beginConfiguration()
            let videoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice!),
                  session.canAddInput(videoInput) else { return }
            // 이건 여기왜 있지?
            session.addInput(videoInput)
            
            
        case .denied, .restricted:
            print("제한이 발생했습니다.")
            isGranted = .notAllowed
        default:
            isGranted = .failed
        }
        
        sessionQueue.async {
            self.configureSession()
        }
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
    
    private func configureSession() {
        if isGranted != .success {
            print("허용되지 않았습니다")
            return
        }
        
        session.beginConfiguration()
        // session Quality level
        session.sessionPreset = .photo
        
        // 비디오 인풋 전달 받기
        do {
            
        }
    }
}
