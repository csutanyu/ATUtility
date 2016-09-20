//
//  WigglingCollectionView.swift
//  ATUtility
//
//  Created by arvin.tan on 5/16/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

import UIKit

// Customized CollectionView with a wiggle animation similar to iOS deletion animation
// Reference: https://github.com/LiorNn/DragDropCollectionView

class WigglingCollectionView: UICollectionView {
    var isWiggling: Bool
    
    required init?(coder aDecoder: NSCoder) {
        self.isWiggling = false
        super.init(coder: aDecoder)
    }
    
    func startWiggle() {
        for cell in visibleCells {
            addWiggleAnimationToCell(cell)
        }
        isWiggling = true
    }
    
    func stopWiggle() {
        for cell in visibleCells {
            cell.layer.removeAllAnimations()
        }
        isWiggling = false
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if isWiggling {
            addWiggleAnimationToCell(cell)
        } else {
            cell.layer.removeAllAnimations()
        }
        return cell
    }
    
    func addWiggleAnimationToCell(_ cell: UICollectionViewCell) {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        cell.layer.add(rotationAnimation(), forKey: "rotation")
        cell.layer.add(bounceAnimation(), forKey: "bounce")
        CATransaction.commit()
    }
    
    fileprivate func rotationAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let angle = CGFloat(0.04)
        let duration = TimeInterval(0.1)
        let variance = Double(0.025)
        animation.values = [angle, -angle]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    fileprivate func bounceAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let bounce = CGFloat(3.0)
        let duration = TimeInterval(0.12)
        let variance = Double(0.025)
        animation.values = [bounce, -bounce]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    fileprivate func randomizeInterval(_ interval: TimeInterval, withVariance variance:Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random;
    }
}
