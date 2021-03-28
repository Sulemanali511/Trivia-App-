

import Foundation
import UIKit
import SwiftMessages
import Toast_Swift
import SVProgressHUD
import SwiftyJSON
import AVFoundation
enum ToastType {
    case success
    case failure
    case warning
}

class Functions: NSObject {
    
    
    
    static func showToast(message:String,type:ToastType = .warning,duration:Double = 2.0 ,position:ToastPosition = .center){
        
        var style = ToastStyle()
        if type == .success{
            style.backgroundColor = .black
        }else if type == .failure{
            style.backgroundColor = .systemRed
        }else if type == .warning{
            style.backgroundColor = .systemBlue
            
        }
        let window = UIApplication.shared.keyWindow!
        window.hideAllToasts()
        window.makeToast(message, duration: duration, position: position, title: nil, image: nil, style: style) { (didTap) in
            if didTap {
                window.hideAllToasts()
            } else {
                print("completion without tap")
            }
            
        }
    }
    static func showActivity(progres:Double = 0.0){
        if progres == 0.0{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            
        }else{
            let value = progres*100
            SVProgressHUD.showProgress(Float(progres), status: String(format: "%.1f percent", value))
            SVProgressHUD.setBackgroundColor(.lightGray)
        }
    }
    
    static func hideActivity(){
        SVProgressHUD.dismiss()
    }
    
    static func noInternetConnection(status:Bool){
        
        if status == true{
            SwiftMessages.hideAll()
            SwiftMessages.pauseBetweenMessages = 0.0
            
            let view: MessageView
            view = try! SwiftMessages.viewFromNib()
            
            view.configureContent(title: "", body: "Please check your internet connection", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in
                
                SwiftMessages.hide()
                
            })
            view.accessibilityPrefix = "error"
            view.configureDropShadow()
            view.button?.isHidden = true
            
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            config.presentationContext = .window(windowLevel: .statusBar)
            config.preferredStatusBarStyle = .lightContent
            config.interactiveHide = false
            config.duration = .forever
            view.configureTheme(backgroundColor: UIColor.red, foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
            
            config.dimMode = .gray(interactive: true)
            SwiftMessages.show(config: config, view: view)
            
        }else{
            SwiftMessages.hide()
            SwiftMessages.hideAll()
            SwiftMessages.pauseBetweenMessages = 0.0
        }
        
    }
    
    
    
    static func showMessageBanner(with json : JSON)
    {
        AudioServicesPlaySystemSound(SystemSoundID(1007))
        SwiftMessages.hideAll()
        SwiftMessages.pauseBetweenMessages = 0.0
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: json["senderName"].stringValue, body: json["message"].stringValue, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureTheme(backgroundColor: UIColor.darkGray, foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
        view.button?.isHidden = true
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: .normal)
        config.preferredStatusBarStyle = .lightContent
        config.interactiveHide = true
        SwiftMessages.show(config: config, view: view)
        
        view.tapHandler = { _ in
            SwiftMessages.hide()
            //Functions.moveToViewController(json: json)
        }
        
    }
    
    
    
    /**
     https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
     */
    static func checkColorBrightness(hexString:String) -> Int{
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        let test = ((r * 299) + (g * 587) + (b * 114)) / 1000
        return Int(test)
        //  self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        
    }
    
    
}
