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
        let fileName = "\(UUID().uuidString).mov"
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
    
    func saveData(_ data: Data, toFileNamed fileName: String, inDirectory folderName: String) {
        guard let directoryUrl = createDirectory(named: folderName) else {
            print("\(folderName)가 아직 없습니다.")
            return
        }
        
        let fileUrl = directoryUrl.appendingPathComponent(fileName)
        do {
            try data.write(to: fileUrl, options: .atomic)
            print("데이터가 \(fileUrl) 위치에 저장되었습니다.")
        } catch {
            print("데이터가 저장되지 않았습니다. \(error.localizedDescription)")
        }
    }
}

extension RecordVideoModule: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error {
            print("녹화 저장에 문제가 생겼습니다: \(error.localizedDescription)")
            print("Error details: \(error)") // 데이터가 중복 폴더가 존재한다는 점 디버깅
        } else {
            
            // 중복 파일 존재하는지 확인
            if !FileManager.default.fileExists(atPath: outputFileURL.path) {
                print("Source file does not exist: \(outputFileURL.path)")
                return
            }
            
            // ouput 값을 파일로 변경
            do {
                let fileData = try Data(contentsOf: outputFileURL)
                let fileName = outputFileURL.lastPathComponent
                // fileData - 데이터 용량
                print("데이터 명칭:", fileData)
                print("파일 명칭:", fileName)
                print("어떤 데이터?", outputFileURL)
                
                // 영상 파일을 저장
                saveData(fileData, toFileNamed: fileName, inDirectory: "UserVideos")
                
                // Optionally, delete the temporary file after saving
                try FileManager.default.removeItem(at: outputFileURL)
                
            } catch {
                print("Error reading file data or saving it: \(error.localizedDescription)")
            }
        }
    }
}
