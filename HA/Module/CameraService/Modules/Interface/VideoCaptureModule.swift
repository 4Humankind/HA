//
//  VideoCaptureModule.swift
//  HA
//
//  Created by Porori on 5/25/24.
//

import AVFoundation
import UIKit

protocol VideoCaptureModuleInterface: AnyObject {
    var captureSession: AVCaptureSession! { get }
    func setupCaptureSession()
    func setupPreviewLayer(to parentView: UIView)
}

class VideoCaptureModule: NSObject, VideoCaptureModuleInterface {
    var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override init() {
        super.init()
    }
    
    func setupPreviewLayer(to parentView: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        parentView.layer.addSublayer(previewLayer)
        previewLayer.frame = parentView.layer.frame
        previewLayer.connection?.videoOrientation = .portrait
    }
    
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
