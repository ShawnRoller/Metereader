//
//  ImageAnalyzerViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/14/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import Vision
import SwiftOCR

class ImageAnalyzerViewController: BaseViewController {

    let UI_TESTING = true
    @IBOutlet weak var imageView: UIImageView!
    public var capturedImage: UIImage!
    private let ocr = SwiftOCR()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UI_TESTING {
            self.capturedImage = self.imageView.image!
        }
        else {
            self.imageView.image = self.capturedImage
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDetection()
    }

    private func setupDetection() {
        let request = getRequest()
        request.reportCharacterBoxes = true
        detectText(in: self.capturedImage, withRequest: request)
    }
    
}

// MARK: - Vision
extension ImageAnalyzerViewController {
    
    private func getRequest() -> VNDetectTextRectanglesRequest {
        return VNDetectTextRectanglesRequest(completionHandler: { [unowned self] (request, error) in
            guard let results = request.results, error == nil else {
                // TODO: - Handle no text detected
                return
            }
            let result = results.compactMap({$0 as? VNTextObservation})
            self.processTextResults(result)
        })
    }
    
    private func processTextResults(_ results: [VNTextObservation]) {
        DispatchQueue.main.async {
            self.imageView.layer.sublayers?.removeSubrange(1...)
            for region in results {
                let frame = self.getFrameForText(box: region)
                self.drawWordBox(forFrame: frame)
                
                if let boxes = region.characterBoxes {
                    for characterBox in boxes {
                        self.drawLetterBox(box: characterBox)
                    }
                }
                
                // Analyze the text
                self.analyze(imageView: self.imageView, frame: frame)
            }
        }
    }
    
    private func detectText(in image: UIImage, withRequest request: VNDetectTextRectanglesRequest) {
        guard let imageCG = image.cgImage else { return }
        let imageHandler = VNImageRequestHandler(cgImage: imageCG, options: [.properties: ""])
        do {
            try imageHandler.perform([request])
        } catch {
            // TODO: handle errors
        }
    }
    
}

// MARK: - Image functions
extension ImageAnalyzerViewController {
    
    private func getFrame(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
        let imageRatio = (image.size.width / image.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / image.size.height
            let width = scale * image.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            let scale = imageView.frame.size.width / image.size.width
            let height = scale * image.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
    }
    
    private func getFrameForText(box: VNTextObservation) -> CGRect {
        guard let boxes = box.characterBoxes else {
            return CGRect.zero
        }
        guard let image = self.imageView.image else {
            return CGRect.zero
        }
        var maxX: CGFloat = 9999
        var maxY: CGFloat = 9999
        var minX: CGFloat = 0
        var minY: CGFloat = 0
        
        for char in boxes {
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        
        let frame = getFrame(for: image, inImageViewAspectFit: self.imageView)
        let topSpace = frame.minY
        let xCoord = maxX * frame.size.width
        let yCoord = ((1 - minY) * frame.size.height) //+ topSpace
        let width = (minX - maxX) * frame.size.width
        let height = (minY - maxY) * frame.size.height
        
        return CGRect(x: xCoord, y: yCoord, width: width, height: height)
    }
    
    private func getFrame(forBox box: VNRectangleObservation, inImageView imageView: UIImageView) -> CGRect {
        guard let image = imageView.image else {
            return CGRect.zero
        }
        
        let maxX: CGFloat = box.topLeft.x
        let maxY: CGFloat = box.topLeft.y
        let minX: CGFloat = box.topRight.x
        let minY: CGFloat = box.topLeft.y
        
        let frame = getFrame(for: image, inImageViewAspectFit: imageView)
        let topSpace = frame.minY
        let xCoord = maxX * frame.size.width
        let yCoord = ((1 - minY) * frame.size.height) + topSpace
        let width = (minX - maxX) * frame.size.width
        let height = (minY - maxY) * frame.size.height
        
        return CGRect(x: xCoord, y: yCoord, width: width, height: height)
    }
    
    private func getFrame(forBox box: VNRectangleObservation, imageView: UIImageView) -> CGRect {
        let xCoord = box.topLeft.x * imageView.frame.size.width
        let yCoord = (1 - box.topLeft.y) * imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
        return CGRect(x: xCoord, y: yCoord, width: width, height: height)
    }
    
    private func getImage(forFrame frame: CGRect, fromImageView imageView: UIImageView) -> UIImage {
        guard let croppedCGImage = imageView.image?.cgImage?.cropping(to: frame) else { return UIImage() }
        return UIImage(cgImage: croppedCGImage)
    }
    
}

// MARK: - OCR
extension ImageAnalyzerViewController {
    
    private func analyze(imageView: UIImageView, frame: CGRect) {
        guard let image = imageView.image else { return }
        let imageFrame = getFrame(for: image, inImageViewAspectFit: imageView)
        var newFrame = frame
        newFrame.origin.y = imageFrame.minY
//        let croppedImage = getImage(forFrame: frame, fromImageView: imageView)
        let croppedImage = getImage(forFrame: newFrame, fromImageView: imageView)
        guard croppedImage.size.width != 0 && croppedImage.size.height != 0 else { return }
        getString(fromImage: croppedImage) { text in
            guard let text = text else { return }
            print(text)
        }
    }
    
    private func getString(fromImage image: UIImage, completion: @escaping (_ imageText: String?) -> Void) {
        self.ocr.recognize(image) { recognizedString in
            completion(recognizedString)
        }
    }
    
}

// MARK: - Drawing
extension ImageAnalyzerViewController {
    
    private func drawWordBox(forFrame frame: CGRect) {
        let outline = CALayer()
        outline.frame = frame
        outline.borderWidth = 2
        outline.borderColor = UIColor.red.cgColor
        
        self.imageView.layer.addSublayer(outline)
    }
    
    private func drawLetterBox(box: VNRectangleObservation) {
        guard let image = self.imageView.image else {
            return
        }
        let frame = getFrame(for: image, inImageViewAspectFit: self.imageView)
        let topSpace = frame.minY
        let xCoord = box.topLeft.x * frame.size.width
        let yCoord = ((1 - box.topLeft.y) * frame.size.height) + topSpace
        let width = (box.topRight.x - box.bottomLeft.x) * frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        outline.borderWidth = 2
        outline.borderColor = UIColor.yellow.cgColor
        
        self.imageView.layer.addSublayer(outline)
    }
    
    
    
}
