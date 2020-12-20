//
//  LocationCell.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 12/2/20.
//

import UIKit

class LocationCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Helper Methods
    func thumbnail(for location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resize(withBounds: CGSize(width: 52, height: 52))
        }
        return UIImage()
    }
    
    func configure(for location: Location) {
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            var address = ""
            if let s = placemark.subThoroughfare {
                address += s + " "
            }
            if let s = placemark.thoroughfare {
                address += s + ", "
            }
            if let s = placemark.locality {
                address += s
            }
            addressLabel.text = address
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f",
                                       location.latitude,
                                       location.longitude)
        }
        
        photoImageView.image = thumbnail(for: location)
    }
    
    // MARK: - Table View Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
