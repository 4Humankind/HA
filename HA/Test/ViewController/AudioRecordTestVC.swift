//
//  AudioRecordTestVC.swift
//  HA
//
//  Created by SeoJunYoung on 5/7/24.
//

import UIKit

import AVFoundation
import SnapKit

class AudioRecordTestVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var recordButton = UIButton()
    var playButton = UIButton()
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var isPlay: Bool = false
    
    override func viewDidLoad() {
        setupView()
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        view.addSubview(recordButton)
        view.addSubview(playButton)
        
        recordButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(view.snp.centerX)
            make.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalTo(view.snp.centerX)
            make.centerY.equalToSuperview()
        }
        
        recordButton.isEnabled = true
        playButton.isEnabled = false
        recordButton.addTarget(self, action: #selector(recordAudioButtonTapped(_:)), for: .primaryActionTriggered)
        playButton.addTarget(self, action: #selector(playAudioButtonTapped(_:)), for: .primaryActionTriggered)
    }
    
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.setUpUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
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
            
            recordButton.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
        } else {
            recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
            // recording failed :(
        }
        
        playButton.isEnabled = true
        recordButton.isEnabled = true
    }
    
    @objc func playAudioButtonTapped(_ sender: UIButton) {
        if isPlay {
            audioPlayer.stop()
            sender.setImage(UIImage(systemName: "Play"), for: .normal)
        } else {
            recordButton.isEnabled = false
            sender.setImage(UIImage(systemName: "stop"), for: .normal)
            preparePlayer()
            audioPlayer.play()
        }
        isPlay.toggle()
    }
    
    func preparePlayer() {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setImage(UIImage(systemName: "Play"), for: .normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //MARK: To upload video on server
    
    func uploadAudioToServer() {
        /*Alamofire.upload(
         multipartFormData: { multipartFormData in
         multipartFormData.append(getFileURL(), withName: "audio.m4a")
         },
         to: "https://yourServerLink",
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         Print(response)
         }
         case .failure(let encodingError):
         print(encodingError)
         }
         })*/
    }
    
}
