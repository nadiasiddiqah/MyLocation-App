//
//  LocationDetailsViewController.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 11/9/20.
//

import Foundation
import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    print()
    return formatter
}()

class LocationsDetailViewController: UITableViewController {
    
    // MARK: - Instance and Reference variables
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    var categoryName = "No Category"
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = ""
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        dateLabel.text = format(date: Date())
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No address found"
        }
    }
    
    // MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    
    
    // MARK: - Helper methods
    func string(from placemark: CLPlacemark) -> String {
        var fullAddress = ""
        if let subThoroughfare = placemark.subThoroughfare {
            fullAddress += subThoroughfare + " "
        }
        if let thoroughfare = placemark.thoroughfare {
            fullAddress += thoroughfare + " "
        }
        if let locality = placemark.locality {
            fullAddress += locality + ", "
        }
        if let administrativeArea = placemark.administrativeArea {
            fullAddress += administrativeArea + ", "
        }
        if let postalCode = placemark.postalCode {
            fullAddress += postalCode + ", "
        }
        if let country = placemark.country {
            fullAddress += country
        }
        return fullAddress
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Navigation Controller Action Methods
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
