//
//  CameraPreviewService.swift
//  HA
//
//  Created by Porori on 5/10/24.
//

import UIKit
import AVFoundation

class CameraPreview: UIView {
    private var captureSession: AVCaptureSession?
    private var imageOutput = AVCapturePhotoOutput()
    private var videoOutput = AVCaptureMovieFileOutput()
    private var countdownLabel = UILabel()
    private var remainingTime: Int = 0
    private var countdownTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
        setupTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTimer() {
        countdownLabel.frame = self.bounds
        self.addSubview(countdownLabel)
        
        countdownLabel.font = UIFont.systemFont(ofSize: 50)
        countdownLabel.textColor = .black
        countdownLabel.backgroundColor = .white
        countdownLabel.isHidden = true
    }
    
    @objc func countDownTime() {
        print("알람이 시작되나요?")
        remainingTime -= 1
        
        if remainingTime == 0 {
            countdownLabel.isHidden = true
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    func startTimer() {
        remainingTime = 10
        countdownLabel.text = "촬영이 시작됩니다. \(remainingTime)"
        countdownLabel.isHidden = false
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTime), userInfo: nil, repeats: false)
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(imageOutput) {
                session.addOutput(imageOutput)
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            self.layer.addSublayer(previewLayer)

            
            session.startRunning()
            self.captureSession = session
        } catch {
            print("Error configuring camera:", error.localizedDescription)
        }
    }
    
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        imageOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: delegate)
    }
    
    func startRecording(delegate: AVCaptureFileOutputRecordingDelegate) {
        let outputPath = NSTemporaryDirectory().appending("output.mov")
        let outputURL = URL(fileURLWithPath: outputPath)
        videoOutput.startRecording(to: outputURL, recordingDelegate: delegate)
    }
    
    func stopRecording() {
        videoOutput.stopRecording()
    }
    
    func stopRunning() {
        captureSession?.stopRunning()
    }
}
