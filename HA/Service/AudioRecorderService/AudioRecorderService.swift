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
    private var audioPlayer: AVAudioPlayer!
    
    // MARK: - Observer Properties
    private var isRecording = Observable(false)
    private var isPlaying = Observable(false)
    
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
            isRecording.value = false
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
    
    func preparePlayer(url: URL) {
        if audioPlayer == nil {
            var error: NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            } catch let error1 as NSError {
                error = error1
                audioPlayer = nil
            }

            if let err = error {
                print("AVAudioPlayer error: \(err.localizedDescription)")
            } else {
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 10.0
            }
        }
    }
}

// MARK: - related record
extension AudioRecorderService {
    
    func startRecording() {
        
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
            audioRecorder.record()
            isRecording.value = true
        } catch {
            isRecording.value = false
            print("Recording Start Fail")
        }
        
    }
    
    func stopRecording() {
        audioRecorder.stop()
        isRecording.value = false
        audioRecorder = nil
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
}

// MARK: - related play
extension AudioRecorderService {
    
    func playAudio(url: URL) {
        preparePlayer(url: url)
        audioPlayer.delegate = self
        
        if audioPlayer != nil {
            isPlaying.value = true
            audioPlayer.play()
        }
    }
    
    func pauseAudio() {
        isPlaying.value = false
        audioPlayer.pause()
    }
}

// MARK: - subscribe
extension AudioRecorderService {
    func subscribeIsRecording(subscribe: @escaping (Bool) -> Void) {
        isRecording.bind { isRecording in
            if let isRecording = isRecording {
                subscribe(isRecording)
            }
        }
    }
    
    func subscribeIsPlaying(subscribe: @escaping (Bool) -> Void) {
        isPlaying.bind { isPlaying in
            if let isPlaying = isPlaying {
                subscribe(isPlaying)
            }
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

extension AudioRecorderService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("FinishPlaying")
        isPlaying.value = false
        audioPlayer = nil
    }
}
