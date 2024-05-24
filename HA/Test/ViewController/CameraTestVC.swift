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

class CameraTestVC: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    private var captureSession: AVCaptureSession!
    private var videoOutput: AVCaptureMovieFileOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoButton = UIButton()
    private var permissionModule: PermissionModuleImpl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionModule = PermissionModuleImpl()
        permissionModule.checkPermissions()
        setupCaptureSession()
        setupVideoButton()
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access the camera.")
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            } else {
                print("Unable to add camera input to the session.")
                return
            }
            
            videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            } else {
                print("Unable to add movie file output to the session.")
                return
            }
            
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }
        
        setupPreviewLayer()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        previewLayer.connection?.videoOrientation = .portrait
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
    @objc func toggleRecording() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
            videoButton.setTitle("Start Recording", for: .normal)
        } else {
            let outputFilePath = NSTemporaryDirectory().appending("output.mov")
            let outputURL = URL(fileURLWithPath: outputFilePath)
            videoOutput.startRecording(to: outputURL, recordingDelegate: self)
            videoButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func urlForVideo(nameWithExtension urlPath: String) -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(urlPath)
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Started recording to: \(fileURL)")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording movie: \(error.localizedDescription)")
        } else {
            print("Finished recording to: \(outputFileURL)")
            saveVideoToPhotoLibrary(outputFileURL)
        }
    }
    
    func saveVideoToPhotoLibrary(_ fileURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            if let error = error {
                print("Error saving video to photo library: \(error.localizedDescription)")
            } else if saved {
                print("Video saved to photo library.")
                self.fetchLatestVideoAsset()
            }
        }
    }
    
    func fetchLatestVideoAsset() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).firstObject
        if let latestVideo = fetchResult {
            print("Fetched latest video asset: \(latestVideo)")
        } else {
            print("No video asset found.")
        }
    }
}
