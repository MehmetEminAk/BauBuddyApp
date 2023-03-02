//
//  Extensions.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 1.03.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    //This function is generating an alert and returning result
    
    func generateAlert(errTitle : String ,errMsg : String , style : UIAlertController.Style = .alert , okAction : Bool = true , otherActions : [UIAlertAction] = []) -> UIAlertController {
        let alert = UIAlertController(title: errTitle, message: errMsg, preferredStyle: style)
        
        if okAction {
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            
        }
        
        if otherActions.count > 0 {
            otherActions.forEach { action in
                alert.addAction(action)
            }
        }
        return alert
    }
    
    
    // This function is presenting alert
    
    func presentAlert(alert : UIAlertController){
        
        // In here ı used to main thread because the uı will change
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }
    
}


extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexValue: UInt32 = 0
        Scanner(string: hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)).scanHexInt32(&hexValue)
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
