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
    private var cameraButton = UIButton()
    private var videoButton = UIButton()
    private var imageOutput = AVCapturePhotoOutput()
    private var captureSession: AVCaptureSession?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermission()
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
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.configureCamera()
                    }
                }
            }
        case .denied:
            print("카메라 사용이 허락되지 않았습니다.")
        case .notDetermined:
            print("허용이 눌리지 않았습니다.")
        case .restricted:
            print("카메라 사용이 불가능합니다.")
        default:
            print("오류 발생")
        }
    }
    
    private func configureCamera() {
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
            view.layer.addSublayer(previewLayer)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            
            session.startRunning()
            self.captureSession = session
            self.cameraPreviewLayer = previewLayer
        } catch {
            print("Error configuring camera:", error.localizedDescription)
        }
    }
    
    @objc private func cameraButtonTapped() {
        print("Camera button tapped")
        capturePhoto()
    }
    
    @objc private func videoButtonTapped() {
        print("Video button tapped")
    }
    
    private func capturePhoto() {
        guard let captureSession = captureSession else {
            print("Capture session is not configured")
            return
        }
        
        imageOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension CameraTestVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            print("Error processing photo")
            return
        }
        
        DispatchQueue.main.async {
            self.captureSession?.stopRunning()
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = self.view.bounds
            self.view.addSubview(imageView)
        }
    }
}
