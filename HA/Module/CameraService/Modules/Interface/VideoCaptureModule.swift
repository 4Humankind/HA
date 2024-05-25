//
//  CaptureSessionModule.swift
//  HA
//
//  Created by Porori on 5/25/24.
//

import AVFoundation

protocol CaptureSessionInterface: AnyObject {
    var captureSession: AVCaptureSession! { get }
}

class CaptureSessionModule: CaptureSessionInterface {
    var captureSession: AVCaptureSession!
    
    init() {}
    
    func setupCaptureSession() {
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
            
            let videoOutput = AVCaptureMovieFileOutput()
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
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}
