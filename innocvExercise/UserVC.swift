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
            self.showAlert(title: "Invalid name", message: "Introduce a valid name")
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
                print("user updated")
                self.prepareUndo()
                self.requestGetUser(id: idUser)
                self.showAlert(title: "Updated \(self.user!.name)", message: "New name: \(self.userName.text!)")
                    
            case .failure(let error):
                print(error)
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
                print("last change undo")
                self.requestGetUser(id: idUser)
                self.showAlert(title: "Undid last change", message: "Restored name: \(name)")
                self.undoCangeBtn.isEnabled = false
                self.userName.text = name
                    
            case .failure(let error):
                print(error)
            }
        }
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
        let idUser:String = String(user!.id)
        let url = urlBase+"/api/User/"+idUser
        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success(_):
                print("user deleted")
                self.navigationController?.popViewController(animated: true)
                    
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestGetUser(id:String){
        let url = urlBase+"/api/User/"+id
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(_):
                let userAux = try? JSONDecoder().decode(User.self, from: response.data!)
                self.user = userAux
            case .failure(let error):
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
