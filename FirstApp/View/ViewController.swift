//
//  ViewController.swift
//  FirstApp
//
//  Created by admin on 3/10/25.
//

import UIKit
internal import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var buttonStart: UIButton!
    
    
    @IBOutlet weak var buttonReset: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    // vẽ các đường vector
    var trackLayer = CAShapeLayer()
    var progessLayer = CAShapeLayer()
    
    private var isClick = false
    private var cancellables = Set<AnyCancellable>()
    
    private let viewmodel = MainViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customButtonStart()
        customButtonReset()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.layer.cornerRadius = 20
        cardView.layer.borderWidth = 8
        cardView.layer.borderColor = BLACK200.cgColor
        
        viewmodel.$time
            .sink{ [weak self] time in
                self?.timeLabel.text = self?.viewmodel.formattedTime(time: time)
                
            }
            .store(in: &cancellables)
        
        setupCricularProgessLayout(view: cardView)
    }
    
    func customButtonStart( ) {

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = ORANGE
        var title = AttributedString("Start")
        
        title.font = UIFont.systemFont(ofSize: 19.0, weight: .bold)
        title.foregroundColor = UIColor.black
        config.attributedTitle = title
        
        buttonStart.configuration = config
        
        let press = UIAction {_ in
            self.isClick = !self.isClick
            
            if(self.isClick){
                self.viewmodel.countDown()
                
                let pauseTime = self.progessLayer.timeOffset
                self.progessLayer.speed = 1.0
                self.progessLayer.timeOffset = 0
                self.progessLayer.beginTime = 0
                
                let timeSincePause = self.progessLayer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
                self.progessLayer.beginTime = timeSincePause
                
            } else{
                self.viewmodel.pause()
                
                let pausedTime = self.progessLayer.convertTime(CACurrentMediaTime(), from: nil)
                self.progessLayer.speed = 0.0
                self.progessLayer.timeOffset = pausedTime
            }
            self.updateTitleButton()
            
        }
        
        buttonStart.addAction(press, for: .touchUpInside)
    }
    
    func customButtonReset( ) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = BLACK400
        config.background.strokeColor = UIColor.white
        config.background.strokeWidth = 3.0
        
        var title = AttributedString("Reset")
        title.font = UIFont.systemFont(ofSize: 19.0, weight: .bold)
        title.foregroundColor = UIColor.white
        config.attributedTitle = title
        
        buttonReset.configuration = config
        
        let press = UIAction {_ in
            self.viewmodel.reset()
            self.isClick = false
            self.updateTitleButton()
            self.progessLayer.removeAllAnimations()
            self.setupCricularProgessLayout(view: self.cardView)

        }
        
        buttonReset.addAction(press, for: .touchUpInside)
    }
    
    func updateTitleButton(){
        var text = "Start"
        if(isClick) {
            text = "Pause"
        }
        
        if var config = self.buttonStart.configuration {
            if var title = config.attributedTitle {
                title.characters = AttributedString(text).characters
                config.attributedTitle = title
                self.buttonStart.configuration = config
            }
        }
        
    }
    
    func setupCricularProgessLayout(view: UIView){
        
        // UIBezierPath vẽ các hình dạng theo dạng vector
        let cricularPath = UIBezierPath(
            // tầm của đường vẽ với bounds là hệ toạ độ bao gồm gốc toạ độ và kích thước (0, 0, width, height)
            arcCenter: CGPoint(x: view.bounds.midX, y: view.bounds.midY),
            // Bán kính của đường vẽ
            radius: 70.0,
            // vị trí bắt đầu vẽ
            startAngle: -CGFloat.pi / 2,
            endAngle: -CGFloat.pi / 2 - 2*CGFloat.pi,
            // theo chiều kim đồng hồ
            clockwise: false
        )
        
        for layer in [trackLayer, progessLayer] {
                layer.frame = view.bounds
                layer.path = cricularPath.cgPath
                layer.fillColor = UIColor.clear.cgColor
                layer.lineWidth = 10
            }
        
        trackLayer.strokeColor = ORANGE.cgColor
        view.layer.insertSublayer(trackLayer, below: timeLabel.layer)
        
        progessLayer.strokeColor = BLACK200.cgColor
        progessLayer.strokeEnd = 1 //0%
        
        
        view.layer.insertSublayer(progessLayer, below: timeLabel.layer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 25*60
        animation.isRemovedOnCompletion = false

        progessLayer.add(animation, forKey: "circleAnimation")
        progessLayer.speed = 0.0
        progessLayer.timeOffset = 0.0
    }
    
}

