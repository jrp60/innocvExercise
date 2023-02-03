//
//  ViewController.swift
//  innocvExercise
//
//  Created by Javier on 1/2/23.
//

import UIKit
import Alamofire
import Foundation

class CreateUserVC: UIViewController {
    
    var urlBase: String = ""

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userBirthday: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getUrl()
//        AF.request(urlBase+"/api/Health").response { response in
//            debugPrint(response)
//        }
    }
    @IBAction func createUser(_ sender: Any) {
        checkInputs()
    }
    
    func checkInputs() {
        if self.userName.text != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let birthdayString = dateFormatter.string(from: self.userBirthday.date)
            let params: Parameters = ["name": self.userName.text!, "birthday": birthdayString]
            AF.request(urlBase+"/api/User", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<299).response { response in
                print("print response")
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    print("user created")
                    print(data)
                case .failure(let error):
                    print("error creating user")
                    print(error)
                }
            }
           
        } else {
            showAlert(title: "Invalid name", message: "Introduce a valid name")
        }
    }
    
    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
            print(url)
            urlBase = url
        }
    }
    
    func showAlert(title:String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
    }

}

