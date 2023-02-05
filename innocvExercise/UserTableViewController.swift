//
//  UserTableViewController.swift
//  innocvExercise
//
//  Created by Javier on 1/2/23.
//

import UIKit
import Alamofire
import Foundation

class UserTableViewController: UITableViewController,UISearchResultsUpdating {
    
    private var users = [User]()
    private var urlBase: String = ""
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchResults = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.autocapitalizationType = .none
        
        getUrl()
    }
    
    override func viewWillAppear(_ animated: Bool){
        getUsers()
    }
    
    func getUrl() {
        if let url = Bundle.main.infoDictionary?["API_URL"] as? String {
            urlBase = url
        }
    }
    
    func getUsers() {
        AF.request(urlBase+"/api/User").responseJSON { response in
            switch response.result {
            case .success(let jsonResponse):
                self.users.removeAll()
                for user in jsonResponse as! [NSDictionary] {
                    let jsondata = try? JSONSerialization.data(withJSONObject: user)
                    let userAux = try? JSONDecoder().decode(User.self, from: jsondata!)
                    if(userAux == nil){
                        continue
                    }
                    self.users.append(userAux!)
                }
                self.tableView.reloadData()
                    
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath)
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.textLabel!.text = user.name

        return cell
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        searchResults = users.filter { $0.name.contains(searchController.searchBar.text!)}
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userCV = segue.destination as? UserVC {
            let indexPath = tableView.indexPathForSelectedRow!
            let user = searchController.isActive ? searchResults[indexPath.row]:users[indexPath.row]
            
            userCV.user = user
        }
    }
    
}
