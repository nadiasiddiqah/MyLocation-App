//
//  LocationDetailsViewController.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 11/9/20.
//

import Foundation
import UIKit

class LocationsDetailViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Navigation Action Methods
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
