# CoolCollectionView
Custom collection view layout - Swift 2.1 &amp; Xcode 7.1.1

override func collectionViewContentSize() -> CGSize
override func prepareLayout()

override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool
override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint
