//
//  CameraPreviewService.swift
//  HA
//
//  Created by Porori on 5/9/24.
//

import UIKit
import AVFoundation

class CameraPreviewService: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("PreviewLayer cannot be created")
        }
        return layer
    }
    
    // session is created optional as session is yet created
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
}
