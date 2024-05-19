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
    private var cameraPreviewLayer: CameraPreview?
    
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
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else { return }
            DispatchQueue.main.async {
                self?.setupCameraPreview()
            }
        }
    }
    
    private func setupCameraPreview() {
        let preview = CameraPreview()
        view.addSubview(preview)
        preview.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(300)
        }
        self.cameraPreviewLayer = preview
    }
    
    @objc private func cameraButtonTapped() {
        print("Camera button tapped")
        // previewLayer를 활용해서 화면 캡쳐 진행
        cameraPreviewLayer?.capturePhoto(delegate: self)
    }
    
    @objc private func videoButtonTapped() {
        print("Video button tapped")
    }
}

extension CameraTestVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            print("Error processing photo")
            return
        }
        
        DispatchQueue.main.async {
            self.cameraPreviewLayer?.stopRunning()
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = self.view.bounds
            self.view.addSubview(imageView)
        }
    }
}
