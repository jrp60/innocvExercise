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
    var urlBase: String = ""

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var updateUserBtn: UIButton!
    @IBOutlet weak var deleteUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userName.text = user?.name
        getUrl()
    }
    
    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
            print(url)
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
            self.showAlert(title: "Invalid name", message: "Introduce a valid name")
            
        }
    }
    
    func requestPutUser() {
        let idUser:String = String(user!.id)
        let finalUrl = urlBase+"/api/User/"+idUser
        let name = self.userName!.text!
        let birthday = user!.birthdate
        let parameters: [String: Any] = ["id": idUser, "name":name, "birthday":birthday]
        AF.request(finalUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
        switch response.result {
        case .success(let response):
            
            print(response)
            print("user updated")
            self.confirmUpdated()
            //self.navigationController?.popViewController(animated: true)
                
        case .failure(let error):
            print("error 2")
            print(error)
            }
        }
    }
    
    func confirmUpdated() {
        self.showAlert(title: "Updated \(user!.name)", message: "")
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        let alertDelete = UIAlertController(title: "Delete \(user!.name)", message: "Are you sure you want to delete this user?", preferredStyle: .alert)
        alertDelete.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            print("dismiss")
        }))
        alertDelete.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            self.requestDeleteUser()
        }))
        present(alertDelete, animated: true)
    }
    
    func requestDeleteUser(){
        
        let idUser = user?.id
        AF.request(urlBase+"/api/User/\(idUser)", method: .delete).response { response in
        switch response.result {
        case .success(let response):
            
            print(response)
            print("user deleted")
            self.navigationController?.popViewController(animated: true)
                
        case .failure(let error):
            print("error 2")
            print(error)
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
