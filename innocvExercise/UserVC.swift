//
//  UserVC.swift
//  innocvExercise
//
//  Created by Javier on 2/2/23.
//

import UIKit

class UserVC: UIViewController {
    
    var user:User?

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var updateUserBtn: UIButton!
    @IBOutlet weak var deleteUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userName.text = user?.name

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateUser(_ sender: Any) {
    }
    
    @IBAction func deleteUser(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
