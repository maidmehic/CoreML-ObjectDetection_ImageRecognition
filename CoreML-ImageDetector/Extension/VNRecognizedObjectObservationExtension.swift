//
//  VNRecognizedObjectObservationExtension.swift
//  CoreML-ImageDetector
//
//  Created by Maid Mehic on 23/11/2020.
//

import Vision

extension VNRecognizedObjectObservation {
    var label: String? {
        return self.labels.first?.identifier
    }
}
