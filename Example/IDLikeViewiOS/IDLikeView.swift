//
//  IDLikeView.swift
//  IDLikeViewiOS_Example
//
//  Created by Soemsak Loetphornphisit on 22/2/2561 BE.
//  Copyright © 2561 CocoaPods. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class IDLikeView: UIView {
    
//    var touchViews = [UITouch:TouchSpotView]()
    
    var player: AVAudioPlayer?
    var playerClick: AVAudioPlayer?
    var playerClicks: [AVAudioPlayer] = []
    var scene: AnimationScene!
    var size: CGSize!
    var isLongPressing: Bool! = false
    
    var imagesListArray: [UIImage]! = [UIImage]()
    var longImagesListArray: [UIImage]! = [UIImage]()
    var longImageView: UIImageView!
    
    var durationSec = 40
    var duration = 0.0
    var imageCount = 179
    var stillImageCount = 75
    
    var timer: Timer?

    lazy var subView: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin,
                                    UIViewAutoresizing.flexibleRightMargin,
                                    UIViewAutoresizing.flexibleBottomMargin,
                                    UIViewAutoresizing.flexibleTopMargin,
                                    UIViewAutoresizing.flexibleHeight,
                                    UIViewAutoresizing.flexibleWidth]
        return view
    }()
    
    lazy var subView2: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin,
                                 UIViewAutoresizing.flexibleRightMargin,
                                 UIViewAutoresizing.flexibleBottomMargin,
                                 UIViewAutoresizing.flexibleTopMargin,
                                 UIViewAutoresizing.flexibleHeight,
                                 UIViewAutoresizing.flexibleWidth]
        return view
    }()
    
    lazy var scrollView: UIScrollView! = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = true
        view.isPagingEnabled = true
//        view.backgroundColor = UIColor.black
        view.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin,
                                    UIViewAutoresizing.flexibleRightMargin,
                                    UIViewAutoresizing.flexibleBottomMargin,
                                    UIViewAutoresizing.flexibleTopMargin,
                                    UIViewAutoresizing.flexibleHeight,
                                    UIViewAutoresizing.flexibleWidth]
        return view
    }()
    
    // MARK: init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView(numberOfPage: 3)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView(numberOfPage: 3)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        scrollView.contentSize = CGSize(width: (self.bounds.size.width * CGFloat(3)), height: bounds.height)
    }
    
    func clearMemory(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.playerClicks = []
            self.clearMemory()
        }
    }
    
    func setupView(numberOfPage: Int) {
        
        clearMemory()
        
        for imageName in 1...stillImageCount {
            let heartName = "heartclick" + "\(String(format: "%d", imageName))"
            let heartImage:UIImage = UIImage(named: heartName)!
            imagesListArray.append(heartImage)
        }
        for imageName in 1...imageCount {
            let heartName = "heartpumping" + "\(String(format: "%05d", imageName))"
            let heartImage:UIImage = UIImage(named: heartName)!
            longImagesListArray.append(heartImage)
        }
        
        guard let url = Bundle.main.url(forResource: "heartsound2", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        
        subView.frame = self.bounds
        
        scrollView.bounces = false
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        
        print("self.bounds.width \(self.bounds.size.width * CGFloat(numberOfPage))")
        scrollView.contentSize = CGSize(width: (self.bounds.size.width * CGFloat(numberOfPage)), height: bounds.height)
        
        scrollView.addSubview(subView)
        
        subView2.frame = CGRect(x: self.bounds.size.width * (2-1), y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
        scrollView.addSubview(subView2)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(singleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageHold(tapGestureRecognizer:)))
        self.addGestureRecognizer(longPress)
        
        subView.isUserInteractionEnabled = true
        subView.isMultipleTouchEnabled = true
        subView2.isUserInteractionEnabled = true
        subView2.isMultipleTouchEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isMultipleTouchEnabled = true
        self.isMultipleTouchEnabled = true
        self.isUserInteractionEnabled = true
    }
    
    @objc func imageHold(tapGestureRecognizer: UIPinchGestureRecognizer) {
        switch tapGestureRecognizer.state {
        case .began:
            if(isLongPressing == false){
                isLongPressing = true
                longImageView = UIImageView(frame: CGRect(x: 0,y: 0, width: self.frame.size.width, height: self.frame.size.height))
                self.addSubview(initLongAnimate(imageView: longImageView))
                longImageView.startAnimating()
                
                self.player?.currentTime = 0
                self.player?.play()
            }
            
        case .ended:
            self.player?.stop()
            UIView.animate(withDuration: 0.5, animations: {
                self.longImageView.alpha = 0.0
                var xOffset: CGFloat = CGFloat(arc4random_uniform(40))
                if(arc4random_uniform(2)%2 == 0){
                    xOffset = xOffset * -1
                }
                let yOffset: CGFloat = (CGFloat(arc4random_uniform(40)) * -1) - 30
                let newLocation = CGPoint(x: self.longImageView.frame.origin.x + xOffset, y: self.longImageView.frame.origin.y + yOffset)
                self.longImageView.frame.origin = newLocation
            }, completion: { (complete) in
                self.longImageView.removeFromSuperview()
                self.isLongPressing = false
            })
            print("xxx")
        default: break
        }
    }
    
    func showSmallHeart(rect:CGRect) {
        
        let clickView = UIView(frame: rect)
        let imageView = UIImageView(frame: CGRect(x: -30,y: -30, width: 60, height: 60))
        clickView.addSubview(initAnimate(imageView: imageView))
        self.addSubview(clickView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // change 2 to desired number of seconds
            UIView.animate(withDuration: 0.5, animations: {
                clickView.alpha = 0.0
                var xOffset: CGFloat = CGFloat(arc4random_uniform(10))
                if(arc4random_uniform(2)%2 == 0){
                    xOffset = xOffset * -1
                }
                let yOffset: CGFloat = (CGFloat(arc4random_uniform(10)) * -1)
                let newLocation = CGPoint(x: clickView.frame.origin.x + xOffset, y: clickView.frame.origin.y + yOffset)
                clickView.frame.origin = newLocation
            }, completion: { (complete) in
                imageView.removeFromSuperview()
                clickView.removeFromSuperview()
            })

        }
        imageView.startAnimating()
        guard let url2 = Bundle.main.url(forResource: "heartclick4", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            let playerClick = try AVAudioPlayer(contentsOf: url2, fileTypeHint: AVFileType.mp3.rawValue)
            playerClicks.append(playerClick)
            playerClicks.last?.prepareToPlay()
            playerClicks.last?.currentTime = 0
            playerClicks.last?.volume = 0.5
            playerClicks.last?.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Hello World")
        if gestureRecognizer.state == UIGestureRecognizerState.recognized {
            showSmallHeart(rect: CGRect(x: gestureRecognizer.location(in: gestureRecognizer.view).x,y:  gestureRecognizer.location(in: gestureRecognizer.view).y, width: 60, height: 60))
        }
    }
    
    func initAnimate( imageView:UIImageView) -> UIImageView{
        imageView.isHidden = false
        imageView.alpha = 1
        imageView.contentMode = .scaleAspectFit
        let heartName = "heartclick" + "\(String(format: "%d", 1))"
        let heartImage:UIImage = UIImage(named: heartName)!
        imageView.image = heartImage
        
        imageView.animationImages = imagesListArray
        imageView.animationDuration = TimeInterval(2)
        imageView.animationRepeatCount = 1
        
        return imageView
    }
    
    func initLongAnimate( imageView:UIImageView) -> UIImageView{
        imageView.isHidden = false
        imageView.alpha = 1
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = longImagesListArray
        imageView.animationDuration = TimeInterval(7)
        imageView.animationRepeatCount = 1
        
        return imageView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            print(location)
//            showSmallHeart(rect: CGRect(x: location.x,y:  location.y, width: 60, height: 60))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
//            let view = viewForTouch(touch: touch)
//            // Move the view to the new location.
//            let newLocation = touch.location(in: self)
//            view?.center = newLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
//            removeViewForTouch(touch: touch)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
//            removeViewForTouch(touch: touch)
        }
    }
    
}
