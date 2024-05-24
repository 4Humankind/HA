//
//  PermissionModule.swift
//  HA
//
//  Created by Porori on 5/23/24.
//

import Foundation

protocol PermissionModule: AnyObject {
    func checkCameraPermission()
    func checkMicrophonePermission()
    func checkLibraryPermission()
    func checkPermissions()
}
