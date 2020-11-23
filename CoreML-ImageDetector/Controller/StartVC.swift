//
//  StartVC.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 23/11/2020.
//

import UIKit

class StartVC: UIViewController {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoTapped)))
        cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraTapped)))
    }
    
    @objc private func videoTapped() {
        performSegue(withIdentifier: "StartToOD", sender: self)
    }
    
    @objc private func cameraTapped() {
        performSegue(withIdentifier: "StartToIR", sender: self)
    }
}
