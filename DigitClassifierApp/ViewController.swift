//
//  ViewController.swift
//  DigitClassifierApp
//
//  Created by Doyun Kim on 4/22/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    
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
}

