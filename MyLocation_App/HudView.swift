//
//  HudView.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 11/20/20.
//

import Foundation
import UIKit

class HudView: UIView {
    var text = ""
    
    // Draw HudView Object
    class func hud(inView view: UIView,
                   animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false

        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        
        hudView.show(animated: true)

        return hudView
    }
    
    override func draw(_ rect: CGRect) {
        // Redraw HudView Object
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96

        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        // Show HUD Image
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)

            image.draw(at: imagePoint)
        }
        
        // Show HUD text
        let attribs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                       NSAttributedString.Key.foregroundColor: UIColor.white]

        let textSize = text.size(withAttributes: attribs)

        // Use textSize to set its location
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)

        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    // MARK: - Public Methods
    func show(animated: Bool) {
        if animated {
            // view before animation
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            // view during/after animation
            UIView.animate(withDuration: 0.3, delay: 0,
                usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                options: [], animations: {
                    self.alpha = 1
                    self.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    
    func hide() {
        superview?.isUserInteractionEnabled = true

        // animate closing of view
        UIView.animate(withDuration: 0.3, delay: 0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
            options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }

}
