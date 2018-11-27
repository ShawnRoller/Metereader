//
//  ContainerViewControllerProtocol.swift
//  Metereader
//
//  Created by Shawn Roller on 10/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

enum ViewSide {
    case none
    case top
    case left
    case right
    case bottom
}

protocol ContainerViewControllerProtocol where Self: UIViewController {
    func addViewController(_ childVC: UIViewController, with frame: CGRect, from side: ViewSide, completion: ((_ done: Bool) -> Void)?)
    func removeViewController(_ childVC: UIViewController, to side: ViewSide, completion: ((_ done: Bool) -> Void)?)
    func viewControllerIsPresented(_ childVC: UIViewController?) -> Bool
    func setTitle(_ title: String, font: UIFont, fontColor: UIColor, backgroundColor: UIColor)
}

extension ContainerViewControllerProtocol {
    func addViewController(_ childVC: UIViewController, with frame: CGRect, from side: ViewSide, completion: ((_ done: Bool) -> Void)?) {
        guard !viewControllerIsPresented(childVC) else { completion?(false); return }
        
        addChild(childVC)
        var newFrame = frame
        var alpha: CGFloat = 0
        
        switch side {
        case .top:
            newFrame = CGRect(x: frame.minX, y: -frame.height, width: frame.width, height: frame.height)
        case .bottom:
            newFrame = CGRect(x: frame.minX, y: self.view.frame.height + frame.height, width: frame.width, height: frame.height)
        case .left:
            newFrame = CGRect(x: -frame.width, y: frame.minY, width: frame.width, height: frame.height)
        case .right:
            newFrame = CGRect(x: self.view.frame.width, y: frame.minY, width: frame.width, height: frame.height)
        default:
            alpha = 1
        }
        
        if alpha > 0 {
            // Make the view invisible so it can be faded in
            childVC.view.alpha = 0
        }
        childVC.view.frame = newFrame
        self.view.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        
        if alpha > 0 {
            // Fade the view in
            UIView.animate(withDuration: 0.3, animations: {
                childVC.view.alpha = alpha
            }, completion: { (_) in
                completion?(true)
            })
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            childVC.view.frame = frame
        }) { (_) in
            completion?(true)
        }
        
    }
    
    func removeViewController(_ childVC: UIViewController, to side: ViewSide, completion: ((_ done: Bool) -> Void)?) {
        guard viewControllerIsPresented(childVC) else { completion?(true); return }
        
        let frame = childVC.view.frame
        var newFrame = frame
        var alpha: CGFloat = 1
        
        switch side {
        case .top:
            newFrame = CGRect(x: frame.minX, y: -frame.height, width: frame.width, height: frame.height)
        case .bottom:
            newFrame = CGRect(x: frame.minX, y: self.view.frame.height + frame.height, width: frame.width, height: frame.height)
        case .left:
            newFrame = CGRect(x: -frame.width, y: frame.minY, width: frame.width, height: frame.height)
        case .right:
            newFrame = CGRect(x: self.view.frame.width, y: frame.minY, width: frame.width, height: frame.height)
        default:
            alpha = 0
        }
        
        func removeView() {
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
        
        guard alpha > 0 else {
            // Fade the view out
            UIView.animate(withDuration: 0.3, animations: {
                childVC.view.alpha = alpha
            }, completion: { (_) in
                removeView()
                childVC.view.alpha = 1
                completion?(true)
            })
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            childVC.view.frame = newFrame
        }) { (_) in
            removeView()
            completion?(true)
        }
        
    }
    
    func moveViewController(_ childVC: UIViewController, to frame: CGRect, completion: ((_ done: Bool) -> Void)?) {
        guard viewControllerIsPresented(childVC) else {
            completion?(false)
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            childVC.view.frame = frame
            self.view.layoutIfNeeded()
        }) { (_) in
            completion?(true)
        }
    }
    
    func viewControllerIsPresented(_ childVC: UIViewController?) -> Bool {
        var presented = false
        for child in self.children {
            if child == childVC {
                presented = true
                break
            }
        }
        return presented
    }
    
    func setTitle(_ title: String, font: UIFont, fontColor: UIColor, backgroundColor: UIColor) {
        
        guard let navController = self.navigationController else { return }
        let navHeight = navController.navigationBar.frame.height
        let navWidth = navController.navigationBar.frame.width - 300
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navWidth, height: navHeight))
        titleLabel.backgroundColor = backgroundColor
        titleLabel.numberOfLines = 1
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.textAlignment = .center
        titleLabel.textColor = fontColor
        self.navigationItem.titleView = titleLabel
        
    }
}
