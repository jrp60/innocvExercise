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
        getUrl()
    }
    @IBAction func createUser(_ sender: Any) {
        checkInputs()
    }
    
    func checkInputs() {
        if self.userName.text != "" {
            requestPostUser()
        } else {
            showAlert(title: "Invalid name", message: "Introduce a valid name")
        }
    }
    
    func requestPostUser() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let birthdayString = dateFormatter.string(from: self.userBirthday.date)
        let params: Parameters = ["name": self.userName.text!, "birthday": birthdayString]
        AF.request(urlBase+"/api/User", method: .post, parameters: params, encoding: JSONEncoding.default).validate(statusCode: 200..<299).response { response in
            switch response.result {
            case .success(_):
                print("user created")
                self.showAlert(title: "User created", message: "\(self.userName.text!) was created correctly")
                
            case .failure(let error):
                print("error creating user")
                print(error)
            }
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

