//
//  AudioPlayerModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

import AVFoundation

final class AudioPlayerModuleImpl: NSObject, AudioPlayerModule {
    
    // MARK: - Properties
    
    private var audioPlayer: AVAudioPlayer!
    private var isPlaying = false
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
}

// MARK: - Private methods

private extension AudioPlayerModuleImpl {
    
    /// 오디오 플레이어 준비
    func preparePlayer(with url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        } catch {
            print("AVAudioPlayer error: \(error.localizedDescription)")
        }
    }
}

// MARK: - 재생 관련 메서드

extension AudioPlayerModuleImpl {
    
    /// 오디오 재생
    func playAudio(from url: URL) {
        guard !isPlaying else { return }
        preparePlayer(with: url)
        audioPlayer.delegate = self
        if audioPlayer != nil {
            isPlaying = true
            audioPlayer.play()
        }
    }
    
    /// 오디오 다시 재생
    func replayAudio() {
        guard isPlaying else { return }
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    /// 오디오 일시 정지
    func pauseAudio() {
        guard isPlaying else { return }
        audioPlayer.pause()
    }
    
    /// 오디오 정지
    func stopAudio() {
        guard isPlaying else { return }
        audioPlayer.stop()
        audioPlayer = nil
        isPlaying = false
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayerModuleImpl: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        audioPlayer = nil
    }
}
