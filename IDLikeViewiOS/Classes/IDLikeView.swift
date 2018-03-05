//
//  IDLikeView.swift
//  FBSnapshotTestCase
//
//  Created by Soemsak Loetphornphisit on 21/2/2561 BE.
//

import UIKit

public class IDLikeView: UIView {
    
    lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.red
        imageView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin,UIViewAutoresizing.flexibleRightMargin,UIViewAutoresizing.flexibleBottomMargin,UIViewAutoresizing.flexibleTopMargin]
        return imageView
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(imageView)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        
    }

}
