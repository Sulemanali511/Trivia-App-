
import Foundation
import UIKit
import QuartzCore

import AVKit
private let animationDuration: TimeInterval = 1.0
private let deleyTime: TimeInterval = 0
private let springDamping: CGFloat = 0.25
private let lowSpringDamping: CGFloat = 0.50
private let springVelocity: CGFloat = 8.00


@IBDesignable open class CustomView: UIView {
    
    internal var arrProgressChunks = [UIView]() //To generate dymanic Chunks under progressbar
    public var progressTintColor : UIColor!   //Progressbar Tint color
    public var trackTintColor : UIColor!      //Progressbar track color
    public var hideWhenStopped : Bool = true
    public var isAnimating : Bool = false
    public var kChunkWdith = 50.0            //Progressbar Chunk width
    public var noOfChunks = 3                //Number of Chunks to animate
    public var corner:CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
            self.layer.maskedCorners = self.corner
        }
    }
    
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var is_circular: Bool = false {
        didSet {
            if is_circular {
                self.layer.cornerRadius = self.layer.frame.height/2
                self.clipsToBounds = true
            }
            
        }
    }
}



extension CustomView {
    func applyGradient(colours: [UIColor],isVerticale:Bool = false) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if isVerticale{
            gradient.startPoint = CGPoint(x : 0.0, y : 0.5)
            gradient.endPoint = CGPoint(x :1.0, y: 0.5)
        }
        else {
            gradient.startPoint = CGPoint(x : 0.5, y : 0.0)
            gradient.endPoint =   CGPoint(x : 1.0, y: 1.0)
        }
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    //MARK:- Default Animation here
    public func AnimateView(){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Custom Animation here
    public func AnimateViewWithSpringDuration(_ name:UIView, animationDuration:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Low Damping Custom Animation here
    public func AnimateViewWithSpringDurationWithLowDamping(_ name:UIView, animationDuration:TimeInterval, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: lowSpringDamping, springVelocity: springVelocity)
    }
    
    private func provideAnimation(animationDuration:TimeInterval, deleyTime:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: deleyTime,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       })
    }
    
    // Set tint color for track animation
    func trackTintColor (tintColor : UIColor) {
        
        trackTintColor = tintColor
    }
    // Set background color for track
    func progressTintColor (tintColor : UIColor) {
        progressTintColor = tintColor
    }
    // To begin animation
    public func startAnimating() {
        if isAnimating {
            return
        }
        else {
            isAnimating = true
            self.isHidden = false
            
            arrProgressChunks.removeAll()
            for _ in 0..<noOfChunks {
                let chunk = UIView.init(frame: CGRect(x: Double(-kChunkWdith), y: Double(0.0), width: Double(kChunkWdith), height: Double(self.frame.size.height)))
                chunk.layer.cornerRadius = (self.frame.size.height/2)
                arrProgressChunks.append(chunk)
            }
            
            var delay:TimeInterval = 0.0
            for chunk in arrProgressChunks {
                chunk.backgroundColor = self.progressTintColor
                self.addSubview(chunk)
                delay = delay + 0.25
                debugPrint(delay)
                self.doChunkAnimation(chunk: chunk, delay: (delay))
                
            }
        }
    }
    // To stop animation
    public func stopAnimating() {
        if !isAnimating {
            return
        }
        else {
            self.isHidden = self.hideWhenStopped
            
            for  view:UIView in arrProgressChunks {
                view.removeFromSuperview()
            }
            self.arrProgressChunks.removeAll()
        }
    }
    
    // Chunk animation logic
    func doChunkAnimation (chunk : UIView , delay: TimeInterval) {
        
        _ =  [UIView .animate(withDuration: 1.00, delay: delay, options: .curveEaseInOut, animations: {
            var chunkFrame = chunk.frame
            chunkFrame.origin.x = self.frame.size.width
            chunk.frame = chunkFrame
        }, completion: { (finished) in
            var chunkFrame = chunk.frame
            chunkFrame.origin.x = CGFloat(-self.kChunkWdith)
            chunk.frame = chunkFrame
            if finished {
                self.doChunkAnimation(chunk: chunk, delay: 0.4)
            }
        })]
    }
    
}













//MARK:- CustomImageView
@IBDesignable open class CustomImageView: UIImageView {
    
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var is_circular: Bool = false {
        didSet {
            if is_circular {
                self.layer.cornerRadius = self.layer.frame.height/2
                self.clipsToBounds = true
            }
            
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
}


extension CustomImageView {
    
    //MARK:- Default Animation here
    public func AnimateView(){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Custom Animation here
    public func AnimateViewWithSpringDuration(_ name:UIView, animationDuration:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Low Damping Custom Animation here
    public func AnimateViewWithSpringDurationWithLowDamping(_ name:UIView, animationDuration:TimeInterval, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: lowSpringDamping, springVelocity: springVelocity)
    }
    
    private func provideAnimation(animationDuration:TimeInterval, deleyTime:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: deleyTime,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       })
    }
}



//MARK:- CustomButton

@IBDesignable open class CustomButton: UIButton {
    
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
}


extension CustomButton {
    
    //MARK:- Default Animation here
    public func AnimateView(){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Custom Animation here
    public func AnimateViewWithSpringDuration(_ name:UIView, animationDuration:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Low Damping Custom Animation here
    public func AnimateViewWithSpringDurationWithLowDamping(_ name:UIView, animationDuration:TimeInterval, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: lowSpringDamping, springVelocity: springVelocity)
    }
    
    private func provideAnimation(animationDuration:TimeInterval, deleyTime:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: deleyTime,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       })
    }
}

//MARK:- CustomButton
@IBDesignable open class CustomTextField: UITextField {
    
    
    
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:30)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        
        return originalRect.offsetBy(dx: -8, dy: 0)
    }
    
    func addIcon(andImage img:UIImage)
    {
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        imageView.frame = CGRect(x: 13.0, y: 13.0, width: 30, height: 30 )
        let seperatorView = UIView(frame: CGRect(x: 50, y: 0, width: 10, height: 50))
        view.addSubview(seperatorView)
        if !ImageIconOnRight {
            
            self.leftViewMode = .always
            view.addSubview(imageView)
            self.leftViewMode = UITextField.ViewMode.always
            self.leftView = view
        }
        else {
            self.rightViewMode = .always
            view.addSubview(imageView)
            self.rightViewMode = UITextField.ViewMode.always
            self.rightView = view
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            if let str = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil){
                
                return str[NSAttributedString.Key.foregroundColor] as? UIColor
                
                
            }
            else {
                return .systemGray
                
            }
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    @IBInspectable var ImageIconOnRight: Bool = false
    @IBInspectable var AddImageIcon: Bool = false {
        didSet {
            if AddImageIcon{
                addIcon(andImage: IconImage)
            }
        }
    }
    @IBInspectable var IconImage: UIImage = UIImage(){
        didSet{
            addIcon(andImage: IconImage)
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat  = 0 {
        
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
        
    }
    
    
    
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}



extension CustomTextField {
    
    //MARK:- Default Animation here
    public func AnimateView(){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Custom Animation here
    public func AnimateViewWithSpringDuration(_ name:UIView, animationDuration:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Low Damping Custom Animation here
    public func AnimateViewWithSpringDurationWithLowDamping(_ name:UIView, animationDuration:TimeInterval, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: lowSpringDamping, springVelocity: springVelocity)
    }
    
    private func provideAnimation(animationDuration:TimeInterval, deleyTime:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: deleyTime,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       })
    }
}
class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    override init(){
        super.init()
        
        self.picker.allowsEditing = true
        self.picker.mediaTypes = ["public.image"]
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        //        let photoLibrary = UIAlertAction( title: "Photo library", style: .default) {
        //            UIAlertAction in
        //            self.openphotoLibrary()
        //        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        //        alert.addAction(photoLibrary)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            
            
            let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertController.Style.alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.viewController!.present(alertWarning, animated: true, completion: nil)
            
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    func openphotoLibrary(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .savedPhotosAlbum
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

@IBDesignable open class CustomNavigationbar: UINavigationBar{
    @IBInspectable var isTransparent: Bool = false {
        didSet {
            if isTransparent{
                self.setBackgroundImage(UIImage(), for: .default)
                self.shadowImage = UIImage()
                self.isTranslucent = true
                self.backgroundColor = UIColor.clear
                
            }
        }
    }
}


@IBDesignable open class TriangleView : UIView {
    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0
    
    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }
    
    
    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let shape = CAShapeLayer()
    open override func draw(_ rect: CGRect) {
        
        let heightWidth = self.frame.size.width
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))
        
        
        shape.path = path.cgPath
        shape.fillColor = (_color.cgColor)
        
        self.layer.insertSublayer(shape, at: 0)
    }
}
@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
}
