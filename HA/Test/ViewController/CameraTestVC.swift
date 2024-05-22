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
    private var videoOutput: AVCaptureVideoDataOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var takePicture: Bool = false
    private let captureImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAndStartCaptureSession()
        setImageView()
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
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalTo(view.snp.centerX).offset(-50)
        }
    }
    
    private func setupVideoButton() {
        videoButton.setImage(UIImage(systemName: "video"), for: .normal)
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        
        view.addSubview(videoButton)
        videoButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalTo(view.snp.centerX).offset(50)
        }
    }
    
    private func setImageView() {
        view.addSubview(captureImageView)
        captureImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.trailing.equalTo(view.snp.trailing).inset(10)
        }
    }
    
    private func checkPermission() {
        let cameraStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraStatus {
        case .authorized:
            return
        case .denied:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (authorized) in
                if !authorized {
                    abort()
                }
            }
        case .restricted:
            abort()
        default:
            fatalError()
        }
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
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.setOutput()
            
            self.captureSession.commitConfiguration()
            // run on background thread since it blocks main
            self.captureSession.startRunning()
        }
    }
    
    private func setOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("데이터를 내보낼 수 없었습니다.")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
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
    
    // after camera button tapped - returned image portrait is flipped.
    @objc private func cameraButtonTapped() {
        print("Camera button tapped")
        takePicture = true
    }
    
    @objc private func videoButtonTapped() {
        print("Video button tapped")
    }
}

extension CameraTestVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return
        }
        
        // get CVImageBuffer from sample Buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // get ciImage  from buffer and retrieve UIImage
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
            self.captureImageView.image = uiImage
            self.takePicture = false
        }
    }
}
