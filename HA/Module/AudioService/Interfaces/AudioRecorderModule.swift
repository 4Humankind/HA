//
//  AudioRecorderModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

protocol AudioRecorderModule {
    func startRecording()
    func stopRecording()
    func fetchAllRecordingsURLs() -> [URL]
}
