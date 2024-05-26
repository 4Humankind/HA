//
//  PermissionModule.swift
//  HA
//
//  Created by Porori on 5/24/24.
//

import Foundation
import AVFoundation
import Photos

protocol PermissionModuleInterface: AnyObject {
    func checkPermissions()
    func checkCameraPermission(completion: @escaping (Bool) -> Void)
    func checkMicrophonePermission(completion: @escaping (Bool) -> Void)
    func checkLibraryPermission(completion: @escaping (Bool) -> Void)
}

class PermissionModule: NSObject, PermissionModuleInterface {
    
    // in order to create module, NSObject needed
    override init() {
        super.init()
        checkPermissions()
    }
    
    func checkPermissions() {
        checkCameraPermission { granted in
            if !granted {
                print("카메라가 허용되지 않습니다.")
            }
        }
        
        checkMicrophonePermission { granted in
            if !granted {
                print("마이크가 허용되지 않습니다.")
            }
        }
        
        checkLibraryPermission { granted in
            if !granted {
                print("앨범 열람이 되지 않습니다.")
            }
        }
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatus {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    print("카메라가 허용되지 않았습니다.")
                }
            }
        default:
            print("카메라 접근을 할 수 없습니다.")
        }
    }
    
    func checkMicrophonePermission(completion: @escaping (Bool) -> Void) {
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch micStatus {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if !granted {
                    print("마이크가 허용되지 않았습니다.")
                }
            }
        default:
            print("마이크 접근을 할 수 없습니다.")
        }
    }
    
    func checkLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("사진 접근이 가능합니다.")
            case .denied, .limited, .notDetermined, .restricted:
                print("사진 접근이 필요해요.")
            default:
                break
            }
        }
    }
}
