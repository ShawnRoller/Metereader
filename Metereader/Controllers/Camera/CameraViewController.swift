//
//  CameraViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 9/24/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: BaseViewController {

    public var lastReading: Int = 0
    
    @IBOutlet weak var previewView: UIView!
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
}

// MARK: - View lifecycle
extension CameraViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    private func setupCamera() {
        self.captureSession = AVCaptureSession()
        self.captureSession.sessionPreset = .medium
        
        guard let rearCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            self.showAlert(message: "The camera could not be activated. We are unable to take a picture.", buttonTitle: "OK")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: rearCamera)
            self.stillImageOutput = AVCapturePhotoOutput()
            if self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(self.stillImageOutput) {
                self.captureSession.addInput(input)
                self.captureSession.addOutput(self.stillImageOutput)
                setupLivePreview()
            }
        } catch let error {
            self.showAlert(message: error.localizedDescription, buttonTitle: "OK")
        }
    }
    
    private func setupLivePreview() {
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer.videoGravity = .resizeAspect
        self.videoPreviewLayer.connection?.videoOrientation = .portrait
        self.previewView.layer.addSublayer(self.videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    private func processImage(_ image: UIImage?) {
        guard let image = image else {
            showAlert(message: "Something went wrong. Please try to capture the image again.", buttonTitle: "OK")
            return
        }
        performSegue(withIdentifier: Constants.CameraImageAnalyzerSegue, sender: image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ImageAnalyzerViewController, let image = sender as? UIImage else { return }
        destination.capturedImage = image
        destination.lastReading = self.lastReading
    }

}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        processImage(image)
    }
    
}

// MARK: - Tappers
extension CameraViewController {
    
    @IBAction private func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        self.stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
}
