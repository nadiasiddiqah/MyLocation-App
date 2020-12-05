//
//  LocationDetailsViewController.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 11/9/20.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    print()
    return formatter
}()

class LocationsDetailViewController: UITableViewController {
    
    // MARK: - Instance variables
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    var categoryName = "No Category"
    var date = Date()
    
    var managedObjectContext: NSManagedObjectContext!
    
    var descriptionText = ""
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                    longitude: location.longitude)
                placemark = location.placemark
                categoryName = location.category
                date = location.date
                descriptionText = location.locationDescription
            }
        }
    }
    
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
        
        if let location = locationToEdit {
            title = "Edit Location"
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        dateLabel.text = format(date: date)
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
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {

        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }
    
    // MARK: - Navigation Controller Action Methods
    @IBAction func done() {
        let hudView = HudView.hud(inView: navigationController!.view,
                                  animated: true)
        
        let location: Location
        
        if let temp = locationToEdit {
            // Edit Location object
            hudView.text = "Updated"
            location = temp
        } else {
            // Add Location object
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.date = date
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.placemark = placemark
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
            hudView.hide()
        }
        
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView,
                                                    willSelectRowAt indexPath: IndexPath)
                                                    -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
}