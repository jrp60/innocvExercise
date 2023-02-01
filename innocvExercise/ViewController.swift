//
//  ViewController.swift
//  innocvExercise
//
//  Created by Javier on 1/2/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var urlBase: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getUrl()
        AF.request(urlBase+"/api/Health").response { response in
            debugPrint(response)
        }
    }

    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
            print(url)
            urlBase = url
        }
    }

}

