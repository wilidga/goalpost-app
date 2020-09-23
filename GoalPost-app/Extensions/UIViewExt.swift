//
//  UIViewExt.swift
//  GoalPost-app
//
//  Created by Wilman Garcia De Leon on 9/12/20.
//  Copyright © 2020 wilidgadev. All rights reserved.
//

import UIKit

extension UIView {
    func bindTokeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endingFrame.origin.y - startingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                options: KeyframeAnimationOptions(rawValue: curve),
             animations: {self.frame.origin.y += deltaY}, completion: nil)
    }
}

