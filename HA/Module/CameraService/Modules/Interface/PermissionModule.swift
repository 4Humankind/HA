//
//  PermissionModule.swift
//  HA
//
//  Created by Porori on 5/23/24.
//

import Foundation

protocol PermissionModule: AnyObject {
    func checkPermissions()
    func checkCameraPermission(completion: @escaping (Bool) -> Void)
    func checkMicrophonePermission(completion: @escaping (Bool) -> Void)
    func checkLibraryPermission(completion: @escaping (Bool) -> Void)
}
