//
//  CameraTestVC.swift
//  HA
//
//  Created by Porori on 5/9/24.
//

import UIKit
import AVFoundation
import SnapKit

// 현재 문제점
// 1. CameraPreview 화면
// 2. 뒤돌아가기 불가능
// 3. 종속된 상황

class CameraTestVC: UIViewController {
    private var cameraButton = UIButton()
    private var videoButton = UIButton()
    private var isRecording: Bool = false
    private var captureSession: AVCaptureSession!
    private var backCamera: AVCaptureDevice!
    private var frontCamera: AVCaptureDevice!
    private var backInput: AVCaptureInput!
    private var frontInput: AVCaptureInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermission()
        setupAndStartCaptureSession()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupCameraButton()
        setupVideoButton()
    }
    
    private func setupCameraButton() {
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.trailing.equalTo(view.snp.trailing).inset(50)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
    private func setupVideoButton() {
        videoButton.setImage(UIImage(systemName: "video"), for: .normal)
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        
        view.addSubview(videoButton)
        videoButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalTo(view.snp.leading).inset(50)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
    private func checkCameraPermission() {
        
    }
    
    private func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            // enable higher color
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputs()
            
            self.captureSession.commitConfiguration()
            // run on background thread since it blocks main
            self.captureSession.startRunning()
        }
    }
    
    private func setupInputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            fatalError("후면 카메라 생성을 실패했습니다.")
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            fatalError("프런트 카메라 생성을 실패했습니다.")
        }
        
        guard let back = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("후면 카메라가 없습니다.")
        }
        
        backInput = back
        if !captureSession.canAddInput(backInput) {
            fatalError("데이터 전달을 할 수 없습니다.")
        }
        
        guard let front = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("후면 카메라로 데이터 입력을 실패했습니다.")
        }
        
        frontInput = front
        if !captureSession.canAddInput(frontInput) {
            fatalError("데이터 전달이 안됩니다.")
        }
        
        captureSession.addInput(backInput)
        
    }
    
    @objc private func cameraButtonTapped() {
        print("Camera button tapped")
    }
    
    @objc private func videoButtonTapped() {
        print("Video button tapped")
    }
}
