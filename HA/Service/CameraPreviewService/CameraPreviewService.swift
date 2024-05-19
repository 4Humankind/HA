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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func stopRunning() {
        captureSession?.stopRunning()
    }
}
