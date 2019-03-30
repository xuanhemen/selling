//
//  StitchingImageView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/1.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

private let margin : CGFloat = 2.0
private var imageViewWidth :CGFloat = 0.0
class StitchingImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stitchingOnImageView(imageViews:Array<Any>){
        var imageViews = imageViews
        
        if imageViews.count == 1 {
            imageViewWidth = (self.frame.size.width - margin * 3) / 2
        } else if imageViews.count >= 2 && imageViews.count <= 4 {
            imageViewWidth = (self.frame.size.width - margin * 3) / 2
        } else {
            imageViewWidth = (self.frame.size.width - margin * 4) / 3
        }
        
        if imageViews.count == 1
        {
            let imageView_1 : UIImageView = imageViews[0] as! UIImageView
            imageView_1.frame = CGRect(x: (self.frame.size.width - imageViewWidth) / 2, y: (self.frame.size.height - imageViewWidth) / 2, width: imageViewWidth, height: imageViewWidth)
        }
        else if imageViews.count == 2
        {
            let row_1_origin_y : CGFloat = (self.frame.size.height - imageViewWidth) / 2
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y)
        }
        else if imageViews.count == 3
        {
            let row_1_origin_y : CGFloat = (self.frame.size.height - imageViewWidth * 2) / 3
            
            let imageView_1 : UIImageView = imageViews[0] as! UIImageView
            imageView_1.frame = CGRect(x: (self.frame.size.width - imageViewWidth) / 2, y: row_1_origin_y, width: imageViewWidth, height: imageViewWidth)
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y + imageViewWidth + margin)

        }
        else if imageViews.count == 4
        {
            let row_1_origin_y : CGFloat = (self.frame.size.height - imageViewWidth * 2) / 3
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y)

        }
        else if imageViews.count == 5
        {
            let row_1_origin_y = (self.frame.size.height - imageViewWidth * 2 - margin) / 2
            
            let imageView_1 : UIImageView = imageViews[0] as! UIImageView
            imageView_1.frame = CGRect(x: (self.frame.size.width - 2 * imageViewWidth - margin) / 2, y: row_1_origin_y, width: imageViewWidth, height: imageViewWidth)
            
            let imageView_2 : UIImageView = imageViews[1] as! UIImageView
            imageView_2.frame = CGRect(x: imageView_1.frame.origin.x + imageView_1.frame.size.width + margin, y: row_1_origin_y, width: imageViewWidth, height: imageViewWidth)
            
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y + imageViewWidth + margin)

        }
        else if imageViews.count == 6
        {
            let row_1_origin_y : CGFloat = (self.frame.size.height - imageViewWidth * 2 - margin) / 2
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y)

        }
        else if imageViews.count == 7
        {
            let row_1_origin_y = (self.frame.size.height - imageViewWidth * 3) / 4
            
            let imageView_1 : UIImageView = imageViews[0] as! UIImageView
            imageView_1.frame = CGRect(x: (self.frame.size.width - imageViewWidth) / 2, y: row_1_origin_y, width: imageViewWidth, height: imageViewWidth)
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y + imageViewWidth + margin)

        }
        else if imageViews.count == 8
        {
            let row_1_origin_y : CGFloat = (self.frame.size.height - imageViewWidth * 3) / 4
            
            let imageView_1 : UIImageView = imageViews[0] as! UIImageView
            imageView_1.frame = CGRect(x: (self.frame.size.width - 2 * imageViewWidth - margin) / 2, y: row_1_origin_y, width: imageViewWidth, height: imageViewWidth)
            
            let imageView_2 : UIImageView = imageViews[1] as! UIImageView
            imageView_2.frame = CGRect(x: imageView_1.frame.origin.x + imageView_1.frame.size.width + margin, y: row_1_origin_y, width: imageViewWidth, height: imageViewWidth)
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y + imageViewWidth + margin)
            
        }
        else if imageViews.count == 9
        {
            let row_1_origin_y = (self.frame.size.height - imageViewWidth * 3) / 4
            imageViews = self.generatorArr(imageViews: imageViews, beginOriginY: row_1_origin_y)

        }
        
        for imageView in imageViews {
            self.addSubview(imageView as! UIImageView)
        }

    }
    fileprivate func generatorArr(imageViews:Array<Any> , beginOriginY:CGFloat) -> Array<Any> {
        
        var cellCount : Int
        var maxRow : Int
        var maxColumn : Int
        var ignoreCountOfBegining : Int
        
        if imageViews.count <= 4
        {
            maxRow = 2
            maxColumn = 2
            ignoreCountOfBegining = imageViews.count % 2
            cellCount = 4
        }
        else
        {
            maxRow = 3
            maxColumn = 3
            ignoreCountOfBegining = imageViews.count % 3
            cellCount = 9
        }
        for index in 0..<cellCount {
            if index > imageViews.count - 1 {
                break
            }
            if index < ignoreCountOfBegining {
                continue
            }
            let row = (index - ignoreCountOfBegining) / maxRow
            let column = (index - ignoreCountOfBegining) % maxColumn
            let origin_x = margin + imageViewWidth * CGFloat(column) + margin * CGFloat(column)
            let origin_y = beginOriginY + imageViewWidth * CGFloat(row) + margin * CGFloat(row)
            let imageView : UIImageView = imageViews[index] as! UIImageView
            imageView.frame = CGRect(x: origin_x, y: origin_y, width: imageViewWidth, height: imageViewWidth)
        }
        return imageViews
    }
    
}
