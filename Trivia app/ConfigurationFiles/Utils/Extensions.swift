//
//  Extensions.swift
//  Trivia app
//
//  Created by Suleman Ali on 21/12/2020.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}







extension UIViewController {
    func clearNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

    }
    func addNavigationBackButton(){
        let btnCancel = UIBarButtonItem(image: UIImage(named: "ic_back")?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(self.btnBackAction(_:)))
        btnCancel.tintColor = UIColor(named: "ThemeColor")
        self.navigationItem.leftBarButtonItem  = btnCancel
        
    }
    func addPresentBackButton(){
        let btnCancel = UIBarButtonItem(image: UIImage(named: "ic_back")?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(self.btnPresentAction(_:)))
        btnCancel.tintColor = .white
//        btnCancel.tintColor = UIColor(hexStr: "#43276b")
        self.navigationItem.leftBarButtonItem  = btnCancel
        
    }
    @objc func btnBackAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func btnPresentAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    static func vibrate() {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
   
    
    
   
}




extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
