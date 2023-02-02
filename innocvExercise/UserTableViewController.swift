//
//  UserTableViewController.swift
//  innocvExercise
//
//  Created by Javier on 1/2/23.
//

import UIKit
import Alamofire

class UserTableViewController: UITableViewController {
    
    var users = [User]()
    var urlBase: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUrl()
        getUsers()
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
                    let userAux = try? JSONDecoder().decode(User.self, from: jsondata!)
                    if(userAux == nil){
                        continue
                    }
                    self.users.append(userAux as! User)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let userCV = segue.destination as? UserVC {
            let user : User
            user = self.users[self.tableView.indexPathForSelectedRow!.row]
            
            userCV.user = user
        }
    }
    

}
