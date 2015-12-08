//
//  CoolLayout.swift
//  CoolCollection
//
//  Created by Harvey Zhang on 12/7/15.
//  Copyright © 2015 HappyGuy. All rights reserved.
//

import UIKit

///
struct Constants{
    static let FeaturedCellHeight: CGFloat = 280
    static let CommonCellHeight: CGFloat = 100
}

class CoolLayout: UICollectionViewLayout
{
    let offsetCellHeight: CGFloat = 180     // 280 - 100
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    ///
    var itemsCount: Int {
        return (collectionView?.numberOfItemsInSection(0))!
    }
    
    var width: CGFloat { // means this, UIScreen.mainScreen().bounds.width
        return (collectionView?.bounds.width)!
    }
    var height: CGFloat {   // means device screen bounds height
        return (collectionView?.bounds.height)!
        //return CGRectGetHeight(collectionView!.bounds)    // or above
    }
    
    ///
    var featuredItemIndex:Int {
        return max(0, Int((collectionView?.contentOffset.y)! / offsetCellHeight)  )
    }
    var nextItemPercentageOffset: CGFloat { // [0, 1] means how close the next cell is to becoming the featured cell
        return (collectionView?.contentOffset.y)! / offsetCellHeight - CGFloat(featuredItemIndex)
    }
    
    ///
    override func collectionViewContentSize() -> CGSize { // Returns the width and height of the collection view’s contents.
      //let contentHeight =  CGFloat(itemsCount) * Constants.CommonCellHeight + offsetCellHeight     // not right
        let contentHeight = (CGFloat(itemsCount) * offsetCellHeight) + (height - offsetCellHeight)
        return CGSize(width: width, height: contentHeight)
    }
    
    /* Handle common and feature cell height
    
    Tells the layout object to update the current layout.
    Layout updates occur the first time the collection view presents its content and whenever the layout is invalidated explicitly or implicitly because of a change to the view. During each layout update, the collection view calls this method first to give your layout object a chance to prepare for the upcoming layout operation.
    The default implementation of this method does nothing. Subclasses can override it and use it to set up data structures or perform any initial computations needed to perform the layout later.
    */
    override func prepareLayout()
    {
        cache.removeAll(keepCapacity: true)
        
        let standardHeight = Constants.CommonCellHeight
        let featuredHeight = Constants.FeaturedCellHeight
        
        var frame = CGRectZero
        var y: CGFloat = 0
        
        //print("featured item index: \(self.featuredItemIndex) ")
        
        for item in 0 ..< Int(itemsCount)
        {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            let layoutAttr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            layoutAttr.zIndex = item    // like stacking cards style
            
            var h: CGFloat = standardHeight
            
            if item == featuredItemIndex {
                let yOffset = standardHeight * nextItemPercentageOffset
                y = collectionView!.contentOffset.y - yOffset   // scroll up is minus
                h = featuredHeight
            }
            else if item == (featuredItemIndex + 1) && item != itemsCount { // takes care of scolling process next to feature cell
                let maxY = y + standardHeight   // first, make sure this case max Y position
                h = standardHeight + max(offsetCellHeight * nextItemPercentageOffset, 0)    // scrolling cell height
                y = maxY - h    // final, calc the y position
            }
            
            frame = CGRect(x: 0, y: y, width: width, height: h)     // Key point is y and h 's calculation
            layoutAttr.frame = frame
            
            cache.append(layoutAttr)
            y = CGRectGetMaxY(frame)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        super.layoutAttributesForElementsInRect(rect)
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for la in cache {
            if CGRectIntersectsRect(la.frame, rect) {
                layoutAttributes.append(la)
            }
        }
        
        return layoutAttributes
    }
    
    // Asks the layout object if the new bounds require a layout update. The new bounds of the collection view.
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true     // update bounds when scroll the collection view items
    }
    
    // MARK: - UIScrollViewDelegate method
    
    // This method allows your app to respond with an effect similar to the page snapping effect of a paged UIScrollView
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / offsetCellHeight)
        return CGPoint(x: 0, y: itemIndex * offsetCellHeight)
    }
    
}
