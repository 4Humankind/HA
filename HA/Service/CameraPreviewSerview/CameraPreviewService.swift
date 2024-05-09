//
//  CameraPreviewService.swift
//  HA
//
//  Created by Porori on 5/9/24.
//

import UIKit
import AVFoundation

class CameraPreviewService {
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureVideoDataOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    
    func configure() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        // get permission
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else {
                print("허락되지 않았습니다.")
                return
            }
        }
        
        // using default Camera
        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            // video device wrapped in capture device input
            let input = try AVCaptureDeviceInput(device: camera)
            // handle video output
            videoOutput = AVCaptureVideoDataOutput()
            
            // check if output is available
            if let output = videoOutput {
                // add input into Session
                if captureSession.canAddInput(input) && captureSession.canAddOutput(output) {
                    captureSession.addInput(input)
                    captureSession.addOutput(output)
                    captureSession.commitConfiguration()
                }
            }
        } catch {
            print("문제가 있었습니다.")
        }
    }
    
    func configurePreview() {
        let preview = PreviewView()
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        preview.videoPreviewLayer.session = cameraPreviewLayer.session
    }
}
