import UIKit


public typealias Block = ([String]) -> Void

public class BillReader: NSObject  {
    
    private var completionBlock: Block?
    
    public func read(from view: UIViewController, completionBlock: @escaping Block) {
        
        self.completionBlock = completionBlock
        
        let sheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                view.present(imagePicker, animated: true, completion: nil)
            } else {
                // Camera not available
                print("Camera is not available.")
            }
        }
        sheetController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            view.present(imagePicker, animated: true, completion: nil)
        }
        sheetController.addAction(chooseFromLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetController.addAction(cancelAction)
        
        view.present(sheetController, animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension BillReader: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            ReadImage().readTextFromImage(image: image) {
                text in
                self.completionBlock?(text)
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
