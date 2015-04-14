//
//  GeneralAnimations.swift
//  Hamburger Button
//
//  Created by sunlantao on 15/4/5.
//  Copyright (c) 2015年 Robert Böhnke. All rights reserved.
//

import UIKit


let generalAnimation = GeneralAnimations();

class GeneralAnimations: NSObject {
    
    var _completions = Dictionary<CAAnimation, ()->Void>()
    
    let kAnimScale = "transform.scale"
    
    class func shared()->GeneralAnimations!{
        return generalAnimation;
    }
    
    func addAnimationForLayer (
        layer:CALayer!,
        keyPath:String!,
        fromValue:AnyObject!,
        toValue:AnyObject!,
        duration:CFTimeInterval,
        timeFunction:CAMediaTimingFunction!,
        fileMode:String!,
        autoReverse:Bool,
        removedOnCompleted:Bool,
        completion:(()->Void)?)->CABasicAnimation{
            
            var ani = CABasicAnimation(keyPath: keyPath);
            ani.fromValue = fromValue;
            ani.toValue = toValue;
            ani.duration = duration;
            ani.autoreverses = autoReverse;
            ani.removedOnCompletion = removedOnCompleted;
            ani.fillMode = fileMode;
            ani.timingFunction = timeFunction;
            ani.delegate = self;
            
            layer.addAnimation(ani, forKey: ani.keyPath)
            
            var anim = layer.animationForKey(ani.keyPath);
            _completions[anim] = completion;
            
            return ani;
    }

    class func transform3DValue(angle:CGFloat, disZ:CGFloat)->CATransform3D{
        
        var transloate = CATransform3DMakeTranslation(0, 0, -200);
        var rotate = CATransform3DMakeRotation(angle, 0, 1, 0);
        var mat = CATransform3DConcat(rotate, transloate);
        
        return CATransform3DPerspect(mat, center:CGPointZero, disZ: disZ);
    }
    
    class func CATransform3DMakePerspective(center:CGPoint, disZ:CGFloat)->CATransform3D
    {
        var transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
        var transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
        var scale = CATransform3DIdentity;
        scale.m34 = -1.0/disZ;
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
    }
    
    class func CATransform3DPerspect(t:CATransform3D, center:CGPoint, disZ:CGFloat)->CATransform3D
    {
        return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ: disZ));
    }

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    
        if flag{
            let completion = _completions[anim]
            completion?();
            _completions.removeValueForKey(anim)
        }
    }
}
