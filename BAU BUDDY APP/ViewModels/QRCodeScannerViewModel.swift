//
//  QRCodeScannerVC.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 3.03.2023.
//

import Foundation
import AVFoundation

class QRCodeScannerViewModel: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    public let captureSession = AVCaptureSession()
    var searchQuery: String?
    
    var captureCompletion: (() -> Void)?
    var captureError: ((Error) -> Void)?
    
    override init() {
        super.init()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get capture device")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(error.localizedDescription)
            captureError?(error)
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr]
        
    }
    
    func startCapture() {
        if !captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopCapture() {
        if captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            captureError?(NSError(domain: "No metadata object found", code: 0, userInfo: nil))
            return
        }
        
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
            captureError?(NSError(domain: "Unreadable metadata object", code: 0, userInfo: nil))
            return
        }
        
        searchQuery = stringValue
        captureCompletion?()
    }
}
