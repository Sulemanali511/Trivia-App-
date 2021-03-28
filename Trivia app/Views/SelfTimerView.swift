//
//  SelfTimerView.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

protocol SelfTimerViewDelegate {
    func didStart()
    func didEnd()
    func didPause()
    func didUpdate(newValue:TimeInterval)
}

class SelfTimerView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    var delegate:SelfTimerViewDelegate?
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var interval:TimeInterval = 5
    var timeLeft: TimeInterval = 5  {
        didSet{
            interval = timeLeft
        }
    }
    
    var EndText:String = "00:00"
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var lineColor:UIColor = .red {
        didSet{
            timeLeftShapeLayer.strokeColor = lineColor.cgColor
        }
    }
    var TimerLabelColor:UIColor = .red {
        didSet{
            timeLabel.textColor = lineColor
        }
    }
    var TimerLabelFont:UIFont = .systemFont(ofSize: 30, weight: .bold) {
        didSet{
            timeLabel.font = TimerLabelFont
        }
    }
    var lineleftColor:UIColor = .clear {
        didSet{
            timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        }
    }
    var lineWidth:CGFloat = 15{
        didSet {
            bgShapeLayer.lineWidth = lineWidth
            timeLeftShapeLayer.lineWidth = lineWidth
        }
    }
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: backgroundView.frame.midX , y: backgroundView.frame.midY), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = lineWidth
        backgroundView.layer.insertSublayer(bgShapeLayer,at:0)
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: backgroundView.frame.midX , y: backgroundView.frame.midY), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = lineColor.cgColor
        timeLeftShapeLayer.fillColor = lineleftColor.cgColor
        
        timeLeftShapeLayer.lineWidth = lineWidth
        backgroundView.layer.addSublayer(timeLeftShapeLayer)
        timeLabel.text = timeLeft.time
    }
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: backgroundView.frame.midX-50 ,y: backgroundView.frame.midY-25, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.textColor = TimerLabelColor
        timeLabel.text = timeLeft.time
        backgroundView.addSubview(timeLabel)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SelfTimerView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = .clear
       
    }
    func setupUI(){
      
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        // add the animation to your timeLeftShapeLayer
//        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
    }
    
    func start(){
        
        interval = timeLeft
        timeLabel.text = interval.time
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        endTime = Date().addingTimeInterval(interval)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        delegate?.didStart()
    }
    func stop(){
        timer.invalidate()
        delegate?.didPause()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("SelfTimerView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = .clear
    }
    @objc func updateTime() {
        if interval > 0 {
            delegate?.didUpdate(newValue: interval)
            interval = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = interval.time
        } else {
           
            timeLabel.text = EndText
            timer.invalidate()
            
            delegate?.didEnd()
        }
    }
}
extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
