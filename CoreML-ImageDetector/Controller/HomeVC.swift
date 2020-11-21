//
//  HomeVC.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 21/11/2020.
//

import UIKit
import CoreML
import Vision

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mainImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.camereTapped(_:)))
        mainImageView.addGestureRecognizer(gesture)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImageView.image = pickedImage
            
            guard let ciImage = CIImage(image: pickedImage) else {
                fatalError("unable to convert UIImage to CIImage")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading CoreML model fail")
        }
        
        let request = VNCoreMLRequest(model: model) { (vnRequest, error) in
            guard let results = vnRequest.results as? [VNClassificationObservation] else {
                fatalError("result failed to return `VNClassificationObservation` object")
            }
            
            if let firstResult = results.first {
                self.navigationItem.title = firstResult.identifier.capitalized
                self.presentAlert(firstResult.identifier, firstResult.confidence)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("failed to perform request")
        }
    }
    
    func presentAlert(_ title: String, _ confidence: Float) {
        let confidence = String((confidence * 100.0).rounded())
        let alert = UIAlertController(title: title, message: "\(confidence)%", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Find out More!", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "showMore", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @IBAction @objc func camereTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}
