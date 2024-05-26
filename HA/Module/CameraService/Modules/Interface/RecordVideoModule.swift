//
//  RecordVideoModule.swift
//  HA
//
//  Created by Porori on 5/24/24.
//

import UIKit
import AVFoundation

protocol RecordVideoInterface: AnyObject {
    func startRecording()
    func stopRecording()
}

class RecordVideoModule: NSObject, RecordVideoInterface {
    private var videoOutput: AVCaptureMovieFileOutput!
    private var captureSession: AVCaptureSession!
    
    init(session: AVCaptureSession) {
        super.init()
        self.captureSession = session
        self.videoOutput = session.outputs.compactMap { $0 as? AVCaptureMovieFileOutput }.first
    }
    
    func startRecording() {
        guard let videoOutput = videoOutput else {
            print("비디오 아웃풋이 생성되지 않았습니다.")
            return
        }
        
        print("녹화를 시작합니다.")
        let fileName = "\(UUID().uuidString).mp4"
        let outputFilePath = NSTemporaryDirectory().appending(fileName)
        let outputURL = URL(fileURLWithPath: outputFilePath)
        
        videoOutput.startRecording(to: outputURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        print("녹화를 중지합니다")
        videoOutput.stopRecording()
    }
    
    private func createDirectory(named directory: String) -> URL? {
        let fileManager = FileManager.default
        // create and store within 'sandboxed' file system
        // they are unreachable from different apps
        let document = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userVideoURL = document.appendingPathComponent(directory)
        
        if !fileManager.fileExists(atPath: document.path) {
            do {
                try fileManager.createDirectory(at: userVideoURL, withIntermediateDirectories: true)
            } catch {
                print("파일 매니저에 저장하지 못했습니다.")
                return nil
            }
        }
        return userVideoURL
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
}

extension RecordVideoModule: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        
        if let error = error {
            // 데이터가 중복 폴더가 존재한다는 점 디버깅
            print("녹화 오류 상세 설명: \(error)")
        } else {
            guard let directoryUrl = createDirectory(named: "UserVideos") else {
                print("경로 생성에 문제가 생겼습니다.")
                return
            }
            
            let fileName = outputFileURL.lastPathComponent
            let destinationUrl = directoryUrl.appendingPathComponent(fileName)
            
            do {
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    try FileManager.default.removeItem(at: destinationUrl)
                }
                
                try FileManager.default.moveItem(at: outputFileURL, to: destinationUrl)
                print("비디오가 \(destinationUrl.path)에 저장되었습니다.")
            } catch {
                print("저장된 데이터를 이동하는데 문제가 발생했습니다: \(error.localizedDescription)")
                print("Source URL: \(outputFileURL)")
                print("Destination URL: \(destinationUrl)")
            }
        }
    }
}
