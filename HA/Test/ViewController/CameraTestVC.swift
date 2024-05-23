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
//    private var cameraButton = UIButton()
    private var videoButton = UIButton()
    private let captureImageView = UIImageView()
    
    private var captureSession: AVCaptureSession!
    
    private var movieOutput: AVCaptureMovieFileOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var activeInput: AVCaptureDeviceInput!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if setupSession() {
            setupUI()
            setupPreviewLayer()
            startSession()
        }
        
    }
    
    private func setupSession() -> Bool {
        captureSession?.sessionPreset = AVCaptureSession.Preset.high
        
        // setting up camera
        let frontCamera = AVCaptureDevice.default(for: .video)!
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting up video Session \(error.localizedDescription)")
            return false
        }
        
        let microphone = AVCaptureDevice.default(for: .audio)!
        
        do {
            let mic = try AVCaptureDeviceInput(device: microphone)
            
            if captureSession.canAddInput(mic) {
                captureSession.addInput(mic)
            }
        } catch {
            print("Error setting up microphone Session \(error.localizedDescription)")
            return false
        }
        
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    private func startSession() {
        if captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    private func stopRunning() {
        if captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    @objc private func videoButtonTapped() {
        print("Video button tapped")
        startVideoRecording()
        
        DispatchQueue.main.asyncAfter(deadline: (.now() + 60)) {
            self.stopRecording()
        }
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation

        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }

        return orientation
    }
    
    private func startVideoRecording() {
        if !movieOutput.isRecording {
            let connection = movieOutput.connection(with: AVMediaType.video)
            
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
        } else {
            stopRecording()
        }
    }
    
    private func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        }
    }
    
    
    
//    private func setupAndStartCaptureSession() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession = AVCaptureSession()
//            self.captureSession.beginConfiguration()
//            
//            if self.captureSession.canSetSessionPreset(.photo) {
//                self.captureSession.sessionPreset = .photo
//            }
//            // enable higher color
//            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
//            
//            self.setupInputs()
//            
//            self.setVideoOutput()
//            
//            self.captureSession.commitConfiguration()
//            // run on background thread since it blocks main
//            self.captureSession.startRunning()
//        }
//    }
    
//    private func setupInputs() {
//        guard let backCamera = AVCaptureDevice.default(for: .video),
//              let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                        for: .video,
//                                                        position: .front) else {
//            print("카메라 설정이 완료되지 않았습니다.")
//            return
//        }
//        
//        do {
//            let backInput = try AVCaptureDeviceInput(device: backCamera)
//            let frontInput = try AVCaptureDeviceInput(device: frontCamera)
//            
//            if self.captureSession.canAddInput(backInput) {
//                self.captureSession.addInput(backInput)
//            }
//            
//            if self.captureSession.canAddInput(frontInput) {
//                self.captureSession.addInput(frontInput)
//            }
//        } catch {
//            fatalError("카메라에 세션을 더할 수 없었습니다.")
//        }
//    }
    
//    private func setCameraOutput() {
//        photoOutput = AVCapturePhotoOutput()
//        
//        if captureSession.canAddOutput(photoOutput) {
//            captureSession.addOutput(photoOutput)
//        }
//    }
    
    //MARK: - UI setup
    
    private func setupUI() {
        view.backgroundColor = .white
//        setupCameraButton()
        setupVideoButton()
        setImageView()
    }
    
//    private func checkPermission() {
//        let cameraStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//        switch cameraStatus {
//        case .authorized:
//            return
//        case .denied:
//            abort()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (authorized) in
//                if !authorized {
//                    abort()
//                }
//            }
//        case .restricted:
//            abort()
//        default:
//            fatalError()
//        }
//    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
    }
    
//    private func setupCameraButton() {
//        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
//        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
//        
//        view.addSubview(cameraButton)
//        cameraButton.snp.makeConstraints { make in
//            make.size.equalTo(100)
//            make.bottom.equalTo(view.snp.bottom).offset(-50)
//            make.centerX.equalTo(view.snp.centerX).offset(-50)
//        }
//    }
    
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
    
}

//extension CameraTestVC: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        if !takePicture {
//            return
//        }
//        
//        // get CVImageBuffer from sample Buffer
//        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//        
//        // get ciImage  from buffer and retrieve UIImage
//        let ciImage = CIImage(cvImageBuffer: cvBuffer)
//        let uiImage = UIImage(ciImage: ciImage)
//        
//        DispatchQueue.main.async {
//            self.captureImageView.image = uiImage
//            self.takePicture = false
//        }
//    }
//}

extension CameraTestVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("영상 촬영이 시작됩니다.")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error {
            print("영상 촬영 하는데 오류가 있었습니다.")
        } else {
            print("영상 촬영이 끝났습니다.")
        }
    }
}
