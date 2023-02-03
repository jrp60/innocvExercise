//
//  UserTableViewController.swift
//  innocvExercise
//
//  Created by Javier on 1/2/23.
//

import UIKit
import Alamofire
import Foundation

class UserTableViewController: UITableViewController {
    
    var users = [User]()
    var urlBase: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUrl()
        getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool){

        self.tableView.reloadData()
    }
    
    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
            print(url)
            urlBase = url
        }
    }
    
    
    func getUsers() {
        AF.request(urlBase+"/api/User").responseJSON { response in
            switch response.result {
            case .success(let jsonResponse):
                
                
                for user in response.value as! [NSDictionary] {
                    print("user in loop")
                    print(user)
                    let jsondata = try? JSONSerialization.data(withJSONObject: user)
                    var userAux = try? JSONDecoder().decode(User.self, from: jsondata!)
                    if(userAux == nil){
                        continue
                    }
                    self.users.append(userAux!)
                }
                print("array ysers")
                print(self.users)
                self.tableView.reloadData()
                    
            case .failure(let error):
                print("error 2")
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(users.count)
        print("count users")
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath)

        let user = users[indexPath.row]
        cell.textLabel!.text = user.name

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userCV = segue.destination as? UserVC {
            let user : User
            user = self.users[self.tableView.indexPathForSelectedRow!.row]
            
            userCV.user = user
        }
    }
    
}
