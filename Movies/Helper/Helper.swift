//
//  Helper.swift
//  MovieApp
//
//  Created by Gasho on 08.04.2021.
//

import Foundation
import UIKit

struct Helper{
    
    static func displayAlert(_ title: String?, _ message: String?, actionTitle: String?, completition: (() -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))

        guard let vc = UIApplication.topViewController() else { return }
        vc.present(alert, animated: true, completion: completition)
    }
    
    // In case we need to display progres indicator
    static func showProgress(with message: String, completition: (() -> Void)? = nil){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        guard let vc = UIApplication.topViewController() else { return }
        vc.present(alert, animated: true, completion: completition)
    }
    
    static func dismissProgress(completition: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let top = UIApplication.topViewController() as? UIAlertController {
                top.dismiss(animated: true, completion: completition)
            } else {
                print("Unable to init UIAlertViewController")
            }
        }
    }
}
   
    
