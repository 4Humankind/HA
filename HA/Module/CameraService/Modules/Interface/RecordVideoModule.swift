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

class RecordVideoModule: NSObject, RecordVideoInterface {

    private var videoOutput: AVCaptureMovieFileOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override init() {
        super.init()
        
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
    
    private func createDirectory(named directory: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent(directory)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(at: filePath, withIntermediateDirectories: true)
                } catch {
                    print("파일 매니저에 저장하지 못했습니다.")
                }
            }
            print("Document 다이렉토리는 \(filePath)입니다.")
            return filePath
        }
        return nil
    }
    
    func saveData(_ data: Data, toFileNamed fileName: String, inDirectory directoryName: String) {
        guard let directoryUrl = createDirectory(named: directoryName) else {
            print("\(directoryName)가 아직 없습니다.")
            return
        }
        
        let fileUrl = directoryUrl.appendingPathComponent(fileName)
        do {
            try data.write(to: fileUrl)
            print("데이터가 \(fileUrl) 위치에 저장되었습니다.")
        } catch {
            print("데이터가 저장되지 않았습니다. \(error.localizedDescription)")
        }
    }
    
//    func saveVideoToPhotoLibrary(_ fileURL: URL) {
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
//        }) { saved, error in
//            if let error = error {
//                print("Error saving video to photo library: \(error.localizedDescription)")
//            } else if saved {
//                print("Video saved to photo library.")
//                self.fetchLatestVideoAsset()
//            }
//        }
//    }
//    
//    func fetchLatestVideoAsset() {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).firstObject
//        if let latestVideo = fetchResult {
//            print("Fetched latest video asset: \(latestVideo)")
//        } else {
//            print("No video asset found.")
//        }
//    }
}

extension RecordVideoModule: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error {
            print("Error recording movie: \(error.localizedDescription)")
        } else {
            print("Finished recording to: \(outputFileURL)")
            // saveVideoToPhotoLibrary(outputFileURL)
            // self.saveData(<#T##data: Data##Data#>, toFileNamed: outputFileURL, inDirectory: "like so?")
            
        }
    }
}
