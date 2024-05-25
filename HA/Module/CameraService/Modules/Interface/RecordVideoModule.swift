//
//  RecordVideoModule.swift
//  HA
//
//  Created by Porori on 5/24/24.
//

import UIKit
import AVFoundation
import Photos

protocol RecordVideoInterface: AnyObject {
    func startRecording(whenTapped button: UIButton)
    func stopRecording()
}

class RecordVideoModule: NSObject, RecordVideoInterface, AVCaptureFileOutputRecordingDelegate {

    private var videoOutput: AVCaptureMovieFileOutput!
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override init() {
        super.init()
        setupCaptureSession()
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
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func setPreviewLayer(to parentView: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        parentView.layer.addSublayer(previewLayer)
        previewLayer.frame = parentView.layer.frame
        previewLayer.connection?.videoOrientation = .portrait
    }
    
    func startRecording(whenTapped button: UIButton) {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
            button.setTitle("Start Recording", for: .normal)
        } else {
            let outputFilePath = NSTemporaryDirectory().appending("output.mov")
            let outputURL = URL(fileURLWithPath: outputFilePath)
            videoOutput.startRecording(to: outputURL, recordingDelegate: self)
            button.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func stopRecording() {
        print("녹화를 중지합니다")
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
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error {
            print("Error recording movie: \(error.localizedDescription)")
        } else {
            print("Finished recording to: \(outputFileURL)")
            saveVideoToPhotoLibrary(outputFileURL)
        }
    }
}
