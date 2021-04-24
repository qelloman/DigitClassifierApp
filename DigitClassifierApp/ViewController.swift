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

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var detectResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressedClear(_ sender: UIButton) {
        canvasView.clearCanvasView()
    }
    
    @IBAction func pressedUndo(_ sender: Any) {
        canvasView.undoDraw()
    }
    @IBAction func pressedSave(_ sender: UIButton) {
        let drawing = canvasView.getUIImageFromDrawing()
        if let image = CIImage(image: drawing) {
            detect(image: image)
        } else {
            print("No ciimage")
        }

//        let resizedDrawing = resizeImage(image: drawing)
//        let pixel = drawing.pixelData()
//        let resizedPixel = resizedDrawing.pixelData()
//        print(pixel!.count)
//        print(resizedPixel!.count)
//        print(UIScreen.main.scale)
//        UIImageWriteToSavedPhotosAlbum(resizedDrawing, nil, nil, nil)
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let size = CGSize(width: 14, height: 14) // Retina Device Calibration
        let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: size))
            }

    }
    
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

extension UIImage {
    func pixelData() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        return pixelData
    }
 }
