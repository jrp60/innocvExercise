//
//  ViewController.swift
//  innocvExercise
//
//  Created by Javier on 1/2/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        check()
    }

    func check() {
        if let config = Bundle.main.infoDictionary?["API_URL"] as? String {
            print(config)
        }
    }

}

