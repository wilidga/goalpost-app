//
//  UIViewControllerExt.swift
//  GoalPost-app
//
//  Created by Wilman Garcia De Leon on 9/12/20.
//  Copyright © 2020 wilidgadev. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController){
        let transition = CATransition()
        transition.duration = 0.02
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window?.layer.add(transition, forKey: "transition")
        
        present(viewControllerToPresent,animated: false, completion: nil)
    }
    
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController){
        let transition = CATransition()
            transition.duration = 0.02
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
        guard let presentedViewController = presentedViewController else {return}
        
        presentedViewController.dismiss(animated: false) {
            self.view.window?.layer.add(transition,forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
                    
    }
    
    func dismissDetail(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window?.layer.add(transition, forKey: "transition")
        dismiss(animated: false, completion: nil)
    }
}

