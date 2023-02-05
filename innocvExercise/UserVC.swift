//
//  UserVC.swift
//  innocvExercise
//
//  Created by Javier on 2/2/23.
//

import UIKit
import Alamofire
import Foundation

class UserVC: UIViewController {
    
    var user:User?
    private var urlBase: String = ""
    private var lastName: String = ""

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var updateUserBtn: UIButton!
    @IBOutlet weak var deleteUserBtn: UIButton!
    @IBOutlet weak var undoCangeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userName.text = user?.name
        getUrl()
        undoCangeBtn.isEnabled = false
    }
    
    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
            urlBase = url
        }
    }
    
    @IBAction func updateUser(_ sender: Any) {
        checkName()
    }
    
    func checkName(){
        if self.userName.text != "" {
            requestPutUser()
        } else {
            self.showAlert(title: NSLocalizedString("invalidName", comment: ""), message: NSLocalizedString("introduceValidName", comment: ""))
        }
    }
    
    func requestPutUser() {
        let idUser:String = String(user!.id)
        let finalUrl = urlBase+"/api/User/"
        let name = self.userName!.text!
        let birthday = user!.birthdate
        let parameters: [String: Any] = ["id": idUser, "name":name, "birthday":birthday]
        AF.request(finalUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(_):
                self.prepareUndo()
                self.requestGetUser(id: idUser)
                self.showAlert(title: NSLocalizedString("updated", comment: "") + self.user!.name, message: NSLocalizedString("newName", comment: "") +  self.userName.text!)
                    
            case .failure(let error):
                self.showAlert(title: NSLocalizedString("errorUpdateUser", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    func prepareUndo() {
        self.lastName = self.user!.name
        undoCangeBtn.isEnabled = true
    }
    
    @IBAction func undoLastChange(_ sender: Any) {
        let idUser:String = String(user!.id)
        let finalUrl = urlBase+"/api/User/"
        let name = lastName
        let birthday = user!.birthdate
        let parameters: [String: Any] = ["id": idUser, "name":name, "birthday":birthday]
        AF.request(finalUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(_):
                self.requestGetUser(id: idUser)
                self.showAlert(title: NSLocalizedString("undidLastChange", comment: ""), message: NSLocalizedString("restoredName", comment: "") + name)
                self.undoCangeBtn.isEnabled = false
                self.userName.text = name
                    
            case .failure(let error):
                self.showAlert(title: NSLocalizedString("errorUpdateUser", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        let alertDelete = UIAlertController(title: NSLocalizedString("delete", comment: "") + user!.name, message: NSLocalizedString("areYouSureDeleteUser", comment: ""), preferredStyle: .alert)
        alertDelete.addAction(UIAlertAction(title: NSLocalizedString("dismiss", comment: ""), style: .cancel, handler: { action in
            print("dismiss")
        }))
        alertDelete.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive, handler: { action in
            self.requestDeleteUser()
        }))
        present(alertDelete, animated: true)
    }
    
    func requestDeleteUser(){
        let idUser:String = String(user!.id)
        let url = urlBase+"/api/User/"+idUser
        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                    
            case .failure(let error):
                print(error)
                self.showAlert(title: NSLocalizedString("errorDeleteUser", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    func requestGetUser(id:String){
        let url = urlBase+"/api/User/"+id
        AF.request(url).validate(statusCode: 200..<299).responseJSON { response in
            switch response.result {
            case .success(_):
                let userAux = try? JSONDecoder().decode(User.self, from: response.data!)
                self.user = userAux
            case .failure(let error):
                print(error)
                self.showAlert(title: NSLocalizedString("errorGetUser", comment: ""), message: error.localizedDescription)
            }
        }
    }

    func showAlert(title:String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
    }

}
