//
//  ImageAnalyzerViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/14/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import Vision

class ImageAnalyzerViewController: BaseViewController {

    let UI_TESTING = true
    @IBOutlet weak var imageView: UIImageView!
    public var capturedImage: UIImage!
    
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
                self.drawWordBox(box: region)
                
                if let boxes = region.characterBoxes {
                    for characterBox in boxes {
                        self.drawLetterBox(box: characterBox)
                    }
                }
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

// MARK: - Drawing
extension ImageAnalyzerViewController {
    
    private func drawWordBox(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {
            return
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
        
        let xCoord = maxX * self.imageView.frame.size.width
        let yCoord = (1 - minY) * self.imageView.frame.size.height
        let width = (minX - maxX) * self.imageView.frame.size.width
        let height = (minY - maxY) * self.imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        outline.borderWidth = 2
        outline.borderColor = UIColor.red.cgColor
        
        self.imageView.layer.addSublayer(outline)
    }
    
    private func drawLetterBox(box: VNRectangleObservation) {
        let xCoord = box.topLeft.x * self.imageView.frame.size.width
        let yCoord = (1 - box.topLeft.y) * self.imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * self.imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * self.imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        outline.borderWidth = 2
        outline.borderColor = UIColor.yellow.cgColor
        
        self.imageView.layer.addSublayer(outline)
    }
    
}
