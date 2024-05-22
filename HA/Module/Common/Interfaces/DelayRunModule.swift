//
//  DelayRunModule.swift
//  HA
//
//  Created by SeoJunYoung on 5/15/24.
//

import Foundation

protocol DelayRunModule {
    func startDelayedAction(delay: Int, completion: @escaping () -> Void)
    func cancelDelayedAction()
}
