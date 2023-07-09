//
//  ReadImage.swift
//  
//
//  Created by Binshad K B on 02/07/23.
//

import Vision
import UIKit

@available(iOS 13.0, *)
struct ReadImage {
    
    func readTextFromImage(image: UIImage, completion: @escaping (_ text: [String]) -> Void) {
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
            
        let request = VNRecognizeTextRequest() {
            request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }

            
            let recognizedStrings = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
            
            completion(recognizedStrings)
        }
                
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
}
