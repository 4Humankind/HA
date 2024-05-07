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
    
    override func viewDidLoad() {
        setUpUI()
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
        recordButton.addTarget(self, action: #selector(recordAudioButtonTapped(_:)), for: .primaryActionTriggered)
        playButton.addTarget(self, action: #selector(playAudioButtonTapped(_:)), for: .primaryActionTriggered)
    }
    
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        recordService.startRecording()
    }
    
    @objc func playAudioButtonTapped(_ sender: UIButton) {
        recordService.stopRecording()
    }

}

