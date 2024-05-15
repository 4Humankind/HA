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
    
    var recordService = AudioRecorderService()
    var isRecording = false
    var isPlaying = false
    
    override func viewDidLoad() {
        setUpUI()
        
//        recordService.subscribeIsRecording { [weak self] isRecording in
//            self?.isRecording = isRecording
//            if isRecording {
//                self?.recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
//            } else {
//                self?.recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
//                
//            }
//        }
//        
//        recordService.subscribeIsPlaying { [weak self] isPlaying in
//            self?.isPlaying = isPlaying
//            if isPlaying {
//                self?.playButton.setImage(UIImage(systemName: "pause"), for: .normal)
//            } else {
//                self?.playButton.setImage(UIImage(systemName: "play"), for: .normal)
//            }
//        }
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        recordButton.backgroundColor = .green
        playButton.backgroundColor = .red
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
        recordButton.addTarget(self, action: #selector(recordAudioButtonTapped(_:)), for: .primaryActionTriggered)
        playButton.addTarget(self, action: #selector(playAudioButtonTapped(_:)), for: .primaryActionTriggered)
    }
    
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
//        if isRecording {
//            recordService.stopRecording()
//        } else {
//            recordService.startRecording()
//        }
        recordService.startTimer()
    }
    
    @objc func playAudioButtonTapped(_ sender: UIButton) {
//        if isPlaying {
//            recordService.pauseAudio()
//        } else {
//            print(recordService.fetchAllRecordingsURLs())
//            guard let url = recordService.fetchAllRecordingsURLs().first else { return }
//            recordService.playAudio(url: url)
//        }
    }

}

