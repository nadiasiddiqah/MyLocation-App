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
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                imageView.isHidden = false
                addPhotoLabel.text = ""
                
                imageWidth.constant = 260
                let ratio = imageView.image!.size.width / imageView.image!.size.height
                imageHeight.constant = ratio * imageWidth.constant
                
                tableView.reloadData()
            }
        }
    }
    
    var backgroundObserver: Any?
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
        
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = locationToEdit {
            title = "Edit Location"
            if location.hasPhoto {
                if let theImage = location.photoImage {
                    image = theImage
                }
            }
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
        
        listenForBackgroundNotification()
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
    
//    MARK: - Helper methods
    
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
    
    func listenForBackgroundNotification() {
        backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification, object: nil,
            queue: OperationQueue.main) { [weak self] _ in
                if let weakSelf = self {
                    if weakSelf.presentedViewController != nil {
                        weakSelf.dismiss(animated: false, completion: nil)
                    }
                    weakSelf.descriptionTextView.resignFirstResponder()
                }
            }
    }
    
    deinit {
        print("*** Deinit: \(self)")
        NotificationCenter.default.removeObserver(backgroundObserver!)
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
            location.photoID = nil
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.date = date
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.placemark = placemark
        
        // Save image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("*** Error writing file: \(error)")
                }
            }
        }
        
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
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
    
}

// MARK: - Image Picker Extension
extension LocationsDetailViewController: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {

    // MARK: - Image Helper Method
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil,
                                      preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                      handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.takePhotoWithCamera()
        }
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Libary", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Image Picker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                                [UIImagePickerController.InfoKey : Any]) {
        
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
