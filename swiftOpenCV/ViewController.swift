//
//  ViewController.swift
//  swiftOpenCV
//
//  Created by Robin Malhotra on 29/03/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "image.jpeg")
        _ = OpenCVSwiftWrapper.processImageWithOpenCV(image)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

