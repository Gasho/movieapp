//
//  UIStoryboard+Extend.swift
//  EventsApp
//
//  Created by Gasho on 03.03.2021..
//

import Foundation
import UIKit

protocol Storyboarded{
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController{
    
   static func instantiate() -> Self{
        let id = String(describing: self)
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyBoard.instantiateViewController(identifier: id) as! Self
        return vc
    }
}
