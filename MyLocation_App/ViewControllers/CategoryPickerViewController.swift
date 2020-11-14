//
//  CategoryPickerViewController.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 11/12/20.
//

import Foundation
import UIKit

class CategoryPickerViewController: UITableViewController {
    
    // MARK: - Instance and Reference Properties
    var selectedCategoryName = ""
    var selectedIndexPath = IndexPath()
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"]
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<categories.count {
            if categories[index] == selectedCategoryName {
                selectedIndexPath = IndexPath(row: index, section: 0)
                break
            }
        }
    }
    
    // MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectedCategoryName = categories[indexPath.row]
            }
        }
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int)
                            -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
                            -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
    
        let categoryName = categories[indexPath.row]
        cell.textLabel!.text = categoryName
        
        if categoryName == selectedCategoryName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let newCell = tableView.cellForRow(at: indexPath) {
            newCell.accessoryType = .checkmark
        }
        if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
            oldCell.accessoryType = .none
        }
        selectedIndexPath = indexPath
    }
    
}
