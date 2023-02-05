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
    
    private var urlBase: String = ""

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
            showAlert(title: NSLocalizedString("invalidName", comment: ""), message: NSLocalizedString("introduceValidName", comment: ""))
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
                self.showAlert(title: NSLocalizedString("userCreated", comment: ""), message: self.userName.text! + NSLocalizedString("userCreatedCorrectly", comment: ""))
                
            case .failure(let error):
                self.showAlert(title: NSLocalizedString("errorCreateUser", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
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

