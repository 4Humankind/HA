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
    
    var audioService = AudioService()
    var player = AudioPlayerModuleImpl()
    
    override func viewDidLoad() {
        setUpUI()
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
        audioService.delayedExecutionRecording(delay: 5)
    }
    
    @objc func playAudioButtonTapped(_ sender: UIButton) {
        let audios = audioService.fetchAllRecordingsURLs()
        guard let audio = audios.last else { return }
        audioService.playAudio(from: audio)
    }

}

