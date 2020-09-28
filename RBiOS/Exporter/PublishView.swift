//
//  GroupSearchView.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/27/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire

class GroupTableViewCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!
}

class PublishView: UIView, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hStackView: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reportNameLabel: UITextField!
    
    var groups = [String: String]()
    var searchResults = [String]()
    var ui = [BIToolContainerView]()
    var rdlPublisher = RDLPublisher()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.isHidden = true
    }
        
    func publish(ui: [BIToolContainerView]){
        titleLabel.text = "Loading Workspaces..."
        self.ui = ui
        getGroups()
    }
    
    func getGroups(){
        let url = "https://api.powerbi.com/v1.0/myorg/groups"
        let headers: HTTPHeaders = ["Authorization" : RDLPublisher.BEARER]
        AF.request(URL.init(string: url)!, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {
                case .success(_):
                    if let json = response.value as? [String: Any]
                    {
                        guard let groupArray = json["value"] as? [[String:Any]] else{ return }
                        for group in groupArray{
                            self.groups[group["name"]! as! String] = group["id"] as? String
                        }
                        self.searchResults = Array(self.groups.keys).sorted()
                        self.tableView.reloadData()
                        self.titleLabel.text = "Choose a Workspace"
                    }
                    break
                case .failure(let error):
                    print([error as Error])
                    break
                }
            }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GroupTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        cell.label?.text = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.nextButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.nextButton.isEnabled = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            searchResults = Array(groups.keys)
        }
        else {
            searchResults = Array(groups.keys).filter{
                $0.lowercased().contains(searchText.lowercased())
            }.sorted{$0.localizedCompare($1) == .orderedAscending}
            self.tableView.reloadData()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.close()
    }
    
    @IBAction func next(_ sender: Any) {
        if let selectedRow = self.tableView.indexPathForSelectedRow {
            if(reportNameLabel.hasText) {
                rdlPublisher.publish(ui: ui, groupId: self.groups[searchResults[selectedRow.row]]!, reportName: reportNameLabel.text!)
                
                
            }
            else {
                self.tableView.isHidden = true
                self.searchBar.isHidden = true
            }
        }
        
    }
    
    func close(){
        self.searchBar.text = ""
        self.isHidden = true
        self.tableView.isHidden = false
        self.searchBar.isHidden = false
        self.nextButton.isEnabled = false
    }
    
}
