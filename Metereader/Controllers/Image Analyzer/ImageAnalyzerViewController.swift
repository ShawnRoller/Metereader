//
//  ImageAnalyzerViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/14/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import Vision
import SwiftyJSON

class ImageAnalyzerViewController: BaseViewController {

    let UI_TESTING = true
    @IBOutlet weak var imageView: UIImageView!
    public var capturedImage: UIImage!
    
    let googleAPIKey = "AIzaSyCHl_wiateX3k8PfEXEqmlE6AyP1KsX3Eo"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    let session = URLSession.shared
    
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
                self.cloudAnalyze(imageView: self.imageView, frame: frame)
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
        let yCoord = ((1 - minY) * frame.size.height) + topSpace
        let width = (minX - maxX) * frame.size.width
        let height = (minY - maxY) * frame.size.height
        
        return CGRect(x: xCoord, y: yCoord, width: width, height: height)
    }
    
    private func getImage(forFrame frame: CGRect, fromImageView imageView: UIImageView) -> UIImage {
        guard let croppedCGImage = imageView.image?.cgImage?.cropping(to: frame) else { return UIImage() }
        return UIImage(cgImage: croppedCGImage)
    }
    
}

// MARK: - OCR
extension ImageAnalyzerViewController {
    
    private func cloudAnalyze(imageView: UIImageView, frame: CGRect) {
        guard let image = imageView.image else { return }
        let imageFrame = getFrame(for: image, inImageViewAspectFit: imageView)
        let translation = max(image.size.width, image.size.height) / max(imageView.frame.width, imageView.frame.height)
        let newFrame = CGRect(x: frame.origin.x * translation, y: (frame.origin.y - imageFrame.origin.y) * translation, width: frame.width * translation, height: frame.height * translation).scaleUp(scaleUp: 0.25)

        let croppedImage = image.crop(rect: newFrame)
        guard croppedImage.size.width != 0 && croppedImage.size.height != 0 else { return }
        
        // Send request to google
        let binaryImageData = base64EncodeImage(croppedImage)
        createRequest(with: binaryImageData)
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
        
        let outlineFrame = CGRect(x: xCoord, y: yCoord, width: width, height: height)
        let outline = CALayer()
        outline.frame = outlineFrame
        outline.borderWidth = 2
        outline.borderColor = UIColor.yellow.cgColor
        
        self.imageView.layer.addSublayer(outline)
    }
    
}


// MARK: - Google Cloud
extension ImageAnalyzerViewController {
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count ?? 0 > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get face annotations
//                let faceAnnotations: JSON = responses["faceAnnotations"]
//                if faceAnnotations != nil {
//                    let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
//
//                    let numPeopleDetected:Int = faceAnnotations.count
//
//                    self.faceResults.text = "People detected: \(numPeopleDetected)\n\nEmotions detected:\n"
//
//                    var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
//                    var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
//
//                    for index in 0..<numPeopleDetected {
//                        let personData:JSON = faceAnnotations[index]
//
//                        // Sum all the detected emotions
//                        for emotion in emotions {
//                            let lookup = emotion + "Likelihood"
//                            let result:String = personData[lookup].stringValue
//                            emotionTotals[emotion]! += emotionLikelihoods[result]!
//                        }
//                    }
//                    // Get emotion likelihood as a % and display in UI
//                    for (emotion, total) in emotionTotals {
//                        let likelihood:Double = total / Double(numPeopleDetected)
//                        let percent: Int = Int(round(likelihood * 100))
//                        self.faceResults.text! += "\(emotion): \(percent)%\n"
//                    }
//                } else {
//                    self.faceResults.text = "No faces found"
//                }
//
//                // Get label annotations
//                let labelAnnotations: JSON = responses["labelAnnotations"]
//                let numLabels: Int = labelAnnotations.count
//                var labels: Array<String> = []
//                if numLabels > 0 {
//                    var labelResultsText:String = "Labels found: "
//                    for index in 0..<numLabels {
//                        let label = labelAnnotations[index]["description"].stringValue
//                        labels.append(label)
//                    }
//                    for label in labels {
//                        // if it's not the last item add a comma
//                        if labels[labels.count - 1] != label {
//                            labelResultsText += "\(label), "
//                        } else {
//                            labelResultsText += "\(label)"
//                        }
//                    }
//                    self.labelResults.text = labelResultsText
//                } else {
//                    self.labelResults.text = "No labels found"
//                }
            }
        })
        
    }
    
}
