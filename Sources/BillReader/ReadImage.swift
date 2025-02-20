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
            
            let sorted = observations.sorted { (d1, d2) in

                let xmin1 = floor(d1.boundingBox.origin.x * image.size.width)
                let xmin2 = floor(d2.boundingBox.origin.x * image.size.width)
                let ymin1 = floor((1 - d1.boundingBox.origin.y - d1.boundingBox.size.height) * image.size.height)
                let ymin2 = floor((1 - d2.boundingBox.origin.y - d2.boundingBox.size.height) * image.size.height)
                
                if (ymin1 - 10)...(ymin1 + 10) ~= ymin2 {
                    return xmin1 < xmin2
                }

                return ymin1 < ymin2
            }

            
            let recognizedStrings = sorted.compactMap { observation in
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
