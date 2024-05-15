//
//  AudioRecorderService.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

import Foundation

final class AudioService {
    
    // MARK: - Properties
    /// 오디오 녹음 모듈
    var recorderModule: AudioRecorderModule
    /// 오디오 재생 모듈
    var playerModule: AudioPlayerModule
    /// 실행 지연 모듈
    var executionDelayModule: DelayRunModule
    /// 종료 지연 모듈
    var shutdownDelayModule: DelayRunModule
    
    // MARK: - Initialization
    init() {
        self.recorderModule = AudioRecorderModuleImpl()
        self.playerModule = AudioPlayerModuleImpl()
        self.executionDelayModule = DelayRunModuleImpl()
        self.shutdownDelayModule = DelayRunModuleImpl()
    }
}

// MARK: - 녹음 관련 메서드

extension AudioService {
    
    /// 일정 시간 후에 녹음을 시작하는 메서드
    /// - Parameters:
    ///   - delay: 지연 시간(초)
    func delayedExecutionRecording(delay: Int) {
        executionDelayModule.startDelayedAction(delay: delay) { [weak self] in
            guard let self = self else { return }
            self.recorderModule.startRecording()
            // 일정 시간 후 녹음 종료
            shutdownDelayModule.startDelayedAction(delay: 3) {
                self.recorderModule.stopRecording()
            }
        }
    }
    
    /// 녹음 취소
    func cancelRecording() {
        executionDelayModule.cancelDelayedAction()
    }
    
    /// 저장된 모든 녹음 파일의 URL 배열을 반환하는 메서드
    /// - Returns: 녹음 파일의 URL 배열
    func fetchAllRecordingsURLs() -> [URL] {
        return recorderModule.fetchAllRecordingsURLs()
    }
}

// MARK: - 재생 관련 메서드

extension AudioService {
    
    /// 지정된 URL에서 오디오를 재생하는 메서드
    /// - Parameter from: 재생할 오디오의 URL
    func playAudio(from: URL) {
        playerModule.playAudio(from: from)
    }
    
    /// 오디오 재생을 일시 중지하는 메서드
    func pauseAudio() {
        playerModule.pauseAudio()
    }
    
    /// 오디오를 다시 재생하는 메서드
    func replayAudio() {
        playerModule.replayAudio()
    }
    
    /// 오디오 재생을 정지하는 메서드
    func stopAudio() {
        playerModule.stopAudio()
    }
}
