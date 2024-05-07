//
//  AudioRecorderService.swift
//  HA
//
//  Created by SeoJunYoung on 5/7/24.
//

import Foundation

import AVFoundation

class AudioRecorderService: NSObject {
    // MARK: - Properties
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var isRecording: Observable<Bool> = Observable(false)
    
    override init() {
        super.init()
        setup()
    }
}

private extension AudioRecorderService {
    func setup() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            print("AudioRecorderService Active Success")
        } catch {
            print("AudioRecorderService Active Fail")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let time = dateFormatter.string(from: Date())
        let path = getDocumentsDirectory().appendingPathComponent("recording\(time).m4a")
        return path as URL
    }
}

// MARK: - Methods
extension AudioRecorderService {
    
    func startRecording() {
        
        print(#function)
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            isRecording.value = true
            audioRecorder.record()
        } catch {
            isRecording.value = false
            print("Recording Start Fail")
        }
    }
    
    func stopRecording() {
        print(#function)
        audioRecorder.stop()
        audioRecorder = nil
        isRecording.value = false
    }
    
    func getAllRecordingsURLs() -> [URL] {
        let documentsDirectory = getDocumentsDirectory()
        var recordings: [URL] = []
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for fileURL in directoryContents {
                // .m4a 확장자를 가진 파일만 recordings 배열에 추가
                if fileURL.pathExtension == "m4a" {
                    recordings.append(fileURL)
                }
            }
        } catch {
            print("Error while enumerating files \(documentsDirectory.path): \(error.localizedDescription)")
        }
        
        return recordings
    }
    
    func subscribeIsRecording(subscribe: @escaping (Bool) -> Void) {
        isRecording.bind { isRecording in
            guard let isRecording = isRecording else { return }
            subscribe(isRecording)
        }
    }
}

// MARK: - Delegate
extension AudioRecorderService: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording Success")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
}
