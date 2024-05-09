//
//  PreviewView.swift
//  HA
//
//  Created by Porori on 5/10/24.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
//            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
//        }
//        return layer
//    }
//    
//    // session is used to start and stop
//    var session: AVCaptureSession? {
//        get {
//            return videoPreviewLayer.session
//        }
//        set {
//            videoPreviewLayer.session = newValue
//        }
//    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
