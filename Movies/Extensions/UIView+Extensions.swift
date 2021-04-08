//
//  UIView+Extensions.swift
//  EventsApp
//
//  Created by Gasho on 11.03.2021..
//
import UIKit

enum Edge{
    case left
    case top
    case right
    case bottom
}

extension UIView{
    
    func pinToSuperView(_ edges: [Edge] = [.top, .bottom, .left, .right], constant: CGFloat = 0){
        guard let superview = superview else {return}
        edges.forEach{
            switch $0{
            case .top:
                topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            case .left:
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
            case .right:
                rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant).isActive = true
            }
        }
    }
}
