//
//  AudioRecorderModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

import AVFoundation

final class AudioRecorderModuleImpl: NSObject, AudioRecorderModule {
    
    // MARK: - Properties
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var isRecording: Bool = false
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupRecordingSession()
    }
}

// MARK: - Private methods

private extension AudioRecorderModuleImpl {
    
    /// 녹음 세션 설정
    func setupRecordingSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            print("AudioRecorderService Active Success")
        } catch {
            print("AudioRecorderService Active Fail")
        }
    }
    
    /// Documents 디렉터리 경로 반환
    func fetchDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// 새로운 파일 URL 생성
    func createFileURL() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let time = dateFormatter.string(from: Date())
        return fetchDocumentsDirectory().appendingPathComponent("recording_\(time).m4a")
    }
}

// MARK: - 녹음 관련 메서드

extension AudioRecorderModuleImpl {
    
    /// 녹음 시작
    func startRecording() {
        
        let audioFilename = createFileURL()
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true
        } catch {
            isRecording = false
            print("Recording Start Fail")
        }
    }
    
    /// 녹음 중지
    func stopRecording() {
        audioRecorder.stop()
        isRecording = false
        audioRecorder = nil
    }
    
    /// Documents 디렉터리의 모든 녹음 파일 URL 배열 반환
    func fetchAllRecordingsURLs() -> [URL] {
        let documentsDirectory = fetchDocumentsDirectory()
        var recordings: [URL] = []
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for fileURL in directoryContents {
                if fileURL.pathExtension == "m4a" {
                    recordings.append(fileURL)
                }
            }
        } catch {
            print("Error while enumerating files \(documentsDirectory.path): \(error.localizedDescription)")
        }
        
        return recordings
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorderModuleImpl: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording Success")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
}
