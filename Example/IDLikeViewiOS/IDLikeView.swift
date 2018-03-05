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
    
    var player: AVAudioPlayer?
    var scene: AnimationScene!
    var size: CGSize!
    
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
        setupView(numberOfPage: 1)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView(numberOfPage: 1)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        print("draw\(self.bounds.size.width * CGFloat(2))")
        scrollView.contentSize = CGSize(width: (self.bounds.size.width * CGFloat(1)), height: bounds.height)
    }
    
    func setupView(numberOfPage: Int) {
        for imageName in 1...stillImageCount {
            let heartName = "HeartClick" + "\(String(format: "%d", imageName))"
            let heartImage:UIImage = UIImage(named: heartName)!
            imagesListArray.append(heartImage)
        }
        for imageName in 1...imageCount {
            let heartName = "heartpumping" + "\(String(format: "%05d", imageName))"
            let heartImage:UIImage = UIImage(named: heartName)!
            longImagesListArray.append(heartImage)
        }
        
        guard let url = Bundle.main.url(forResource: "heartsound", withExtension: "mp3") else { return }
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
        
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        doubleTap.numberOfTapsRequired = 2
//        self.addGestureRecognizer(doubleTap)
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageHold(tapGestureRecognizer:)))
        self.addGestureRecognizer(longPress)
        
        self.isUserInteractionEnabled = true
        
    }
    
    @objc func imageHold(tapGestureRecognizer: UIPinchGestureRecognizer) {
        switch tapGestureRecognizer.state {
        case .began:
            longImageView = UIImageView(frame: CGRect(x: 0,y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(initLongAnimate(imageView: longImageView))
            longImageView.startAnimating()
            
            self.player?.currentTime = 0
            self.player?.play()
            
//            let timeMusic = Double(currentLike * 50)/1000 - 0.3
//            player.currentTime = timeMusic
//            timeClicked = Date()
//            self.imageView = HeartAnimate().animateHoldStart(likeValue: 0, imageView: imageView)
//            HeartAnimate().playSound(player: self.player!, currentLike: 0)
        case .ended:
//            timeReleased = Date()
//            self.imageView = HeartAnimate().animateHoldStop(currentLike: 0,imageView: imageView ,timeClicked: timeClicked! , timeReleased: timeReleased!)
//            HeartAnimate().stopSound(player: player!)
//            print(imageView.tag)
            self.player?.stop()
            UIView.animate(withDuration: 1.0, animations: {
                self.longImageView.alpha = 0.0
                var xOffset: CGFloat = CGFloat(arc4random_uniform(40))
                if(arc4random_uniform(2)%2 == 0){
                    xOffset = xOffset * -1
                }
                let yOffset: CGFloat = (CGFloat(arc4random_uniform(40)) * -1) - 60
                let newLocation = CGPoint(x: self.longImageView.frame.origin.x + xOffset, y: self.longImageView.frame.origin.y + yOffset)
                self.longImageView.frame.origin = newLocation
            }, completion: { (complete) in
                self.longImageView.removeFromSuperview()
            })
            print("xxx")
        default: break
        }
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Hello World")
        if gestureRecognizer.state == UIGestureRecognizerState.recognized {
            print(gestureRecognizer.location(in: gestureRecognizer.view))
            
            
//            self.player?.currentTime = 0
//            self.player?.
//            self.player?.play()
            
            /*size = self.frame.size
            scene = AnimationScene(size: size)
            
            var sceneView = SKView(frame: self.frame)
            sceneView.backgroundColor = .white
            
            self.addSubview(sceneView)
            sceneView.presentScene(scene)*/
            
            let clickView = UIView(frame: CGRect(x: gestureRecognizer.location(in: gestureRecognizer.view).x,y:  gestureRecognizer.location(in: gestureRecognizer.view).y, width: 60, height: 60))
            let imageView = UIImageView(frame: CGRect(x: -30,y: -60, width: 60, height: 60))
            clickView.addSubview(initAnimate(imageView: imageView))
            self.addSubview(clickView)
            imageView.startAnimating()
            UIView.animate(withDuration: 2.0, animations: {
                clickView.alpha = 0.0
                var xOffset: CGFloat = CGFloat(arc4random_uniform(40))
                if(arc4random_uniform(2)%2 == 0){
                    xOffset = xOffset * -1
                }
                let yOffset: CGFloat = (CGFloat(arc4random_uniform(40)) * -1) - 40
                let newLocation = CGPoint(x: clickView.frame.origin.x + xOffset, y: clickView.frame.origin.y + yOffset)
                clickView.frame.origin = newLocation
            }, completion: { (complete) in
//                UIView.animate(withDuration: 1.0, animations: {
//                    clickView.alpha = 0.0
//                    var xOffset: CGFloat = CGFloat(arc4random_uniform(40))
//                    if(arc4random_uniform(2)%2 == 0){
//                        xOffset = xOffset * -1
//                    }
//                    let yOffset: CGFloat = (CGFloat(arc4random_uniform(20)) * -1)
//                    let newLocation = CGPoint(x: clickView.frame.origin.x + xOffset, y: clickView.frame.origin.y + yOffset)
//                    clickView.frame.origin = newLocation
//                }, completion: { (complete) in
//                    clickView.removeFromSuperview()
//                })
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            print(location)
        }
    }
    
    func initAnimate( imageView:UIImageView) -> UIImageView{
        imageView.isHidden = false
        imageView.alpha = 1
        imageView.contentMode = .scaleAspectFit
        let heartName = "HeartClick" + "\(String(format: "%d", 1))"
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
    
}
