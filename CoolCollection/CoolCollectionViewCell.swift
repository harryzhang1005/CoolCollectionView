//
//  CoolCollectionViewCell.swift
//  CoolCollection
//
//  Created by Harvey Zhang on 12/5/15.
//  Copyright © 2015 HappyGuy. All rights reserved.
//

import UIKit

class CoolCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imageCoverView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var timeRoomLabel: UILabel!
    
    
    func configureCell(item: Item)
    {
        self.titleLabel.text = item.title
        self.speakerLabel.text = item.speaker
        self.timeRoomLabel.text = item.time! + item.room!
        
        self.imgView.image = UIImage(named: item.bgImageName!)  //?.decompressImage
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes)
    {
        super.applyLayoutAttributes(layoutAttributes)
        
        //self.imgView.alpha = 1.0
        self.imageCoverView.alpha = 0.5
        
        let hC = Constants.CommonCellHeight
        let hF = Constants.FeaturedCellHeight
        
        let delta = (layoutAttributes.frame.height - hC) / (hF - hC)
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransformMakeScale(scale, scale)
        timeRoomLabel.alpha = delta
        speakerLabel.alpha = delta
    }
    
}

private extension UIImage {
    
    var decompressImage: UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        drawAtPoint(CGPointZero)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
}
