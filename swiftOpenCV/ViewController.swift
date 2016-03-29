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
        let image = UIImage(named: "screen")
        let imgView = UIImageView(frame: self.view.bounds)
        imgView.image = OpenCVSwiftWrapper.processImageWithOpenCV(image)
        self.view.addSubview(imgView)
        let img2View = UIImageView(image: image)
        img2View.frame = self.view.bounds
        self.view.addSubview(img2View)
        img2View.alpha = 0.5
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

