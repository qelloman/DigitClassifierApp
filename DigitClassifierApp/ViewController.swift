//
//  ViewController.swift
//  DigitClassifierApp
//
//  Created by Doyun Kim on 4/22/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    // Drawing area
    // Intentionally made it square to reduce the distortion when it is transformed to 28 x 28)
    @IBOutlet weak var canvasView: CanvasView!
    // Label to indicate the inference result
    @IBOutlet weak var detectResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Button actions
    
    @IBAction func pressedClear(_ sender: UIButton) {
        canvasView.clearCanvasView()
    }
    
    @IBAction func pressedUndo(_ sender: Any) {
        canvasView.undoDraw()
    }
    
    @IBAction func pressedDetect(_ sender: UIButton) {
        let drawing = canvasView.getUIImageFromDrawing()
        if let image = CIImage(image: drawing) {
            detect(image: image)
        } else {
            print("No ciimage")
        }
    }
    
    // MARK: Execute inference by calling the Vision ML model request method.
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: MNISTClassifier().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            if let firstResult = results.first {
                self.detectResult.text = firstResult.identifier
            }
        }
        // We do not need to handle image size by ourself. This makes life easier!
        request.imageCropAndScaleOption = .scaleFit
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

}

