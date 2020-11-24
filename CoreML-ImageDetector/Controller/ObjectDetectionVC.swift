//
//  ObjectDetectionVC.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 23/11/2020.
//

import UIKit
import CoreML
import Vision

class ObjectDetectionVC: UIViewController {
    
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var boundingBoxView: BoundingBoxView!
    
    //MARK: - Vision Properties
    var visionModel: VNCoreMLModel?
    var request: VNCoreMLRequest?
    var isInferencing = false
    let objectDetectionModel = YOLOv3Tiny()
    
    //MARK: - AV properties
    var videoCapture: VideoCapture!
    let semaphore = DispatchSemaphore(value: 1)
    var lastExecution = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModelAndRequest()
        setupVideoPreview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    func setupModelAndRequest() {
        if let model = try? VNCoreMLModel(for: objectDetectionModel.model) {
            visionModel = model
            
            //setup request only once and run it multiple times
            request = VNCoreMLRequest(model: visionModel!, completionHandler: { (request, error) in
                if let predictions = request.results as? [VNRecognizedObjectObservation] {
                    DispatchQueue.main.async {
                        self.boundingBoxView.predictedObjects = predictions
                        self.isInferencing = false
                    }
                } else {
                    self.isInferencing = false
                }
                
                self.semaphore.signal()
            })
            
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("Failed to create vision model and request")
        }
    }
    
    func runRequest(pixelBuffer: CVPixelBuffer) {
        guard let request = self.request else { fatalError("No request") }
        self.semaphore.wait()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform request")
        }
    }
    
    func setupVideoPreview() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        
        videoCapture.setUp(sessionPreset: .inputPriority) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.previewView.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = previewView.bounds
    }
}

extension ObjectDetectionVC: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true
            self.runRequest(pixelBuffer: pixelBuffer)
        }
    }
}
