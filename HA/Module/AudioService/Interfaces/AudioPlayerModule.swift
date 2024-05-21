//
//  AudioPlayerModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

protocol AudioPlayerModule {
    func playAudio(from url: URL)
    func replayAudio()
    func pauseAudio()
    func stopAudio()
}
