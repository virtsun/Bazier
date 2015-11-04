//
//  ViewController.swift
//  BazierMaker
//
//  Created by sunlantao on 15/4/8.
//  Copyright (c) 2015年 sunlantao. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, BazerMakeDelege{
    
    var ctrl1Label:UILabel!
    var ctrl2Label:UILabel!
    
    var shape : CAShapeLayer!
    
    var maker : BazerMaker!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    var anim : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        maker = BazerMaker(frame: self.view.bounds)
    
        maker.coordReference = CGPoint(x: 200, y: 300);
        maker.delegate = self
        
        self.view .addSubview(maker)
        
        ctrl1Label = UILabel()
        ctrl1Label.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 20, 200, 20);
        ctrl1Label.textColor = UIColor.brownColor()
        
        self.view.addSubview(ctrl1Label)
        
        ctrl2Label = UILabel()
        ctrl2Label.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 200, CGRectGetHeight(self.view.bounds) - 20, 200, 20);
        ctrl2Label.textColor = UIColor.brownColor()
        ctrl2Label.textAlignment = NSTextAlignment.Right
        self.view.addSubview(ctrl2Label)
        
        addItem()
        
        let apply = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.bounds) - 60, 20, 60, 20));
        apply.setTitle("Go", forState: UIControlState.Normal)
        apply.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        apply.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.6), forState: UIControlState.Normal)

        apply.addTarget(self, action: "apply:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(apply)
        
        let reset = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.bounds) - 60, 60, 60, 20));
        reset.setTitle("Reset", forState: UIControlState.Normal)
        reset.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        reset.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.6), forState: UIControlState.Normal)
        
        reset.addTarget(self, action: "reset:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(reset)
        
        anim = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.bounds) - 80, CGRectGetHeight(self.view.bounds) - 80, 60, 60));
        anim.setTitle("Anim", forState: UIControlState.Normal)
        anim.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
        anim.setTitleColor(UIColor.brownColor().colorWithAlphaComponent(0.6), forState: UIControlState.Highlighted)
        
        anim.addTarget(self, action: "selectAnim:", forControlEvents: UIControlEvents.TouchUpInside)
        
        anim.backgroundColor = UIColor.lightGrayColor()
        
        anim.layer.cornerRadius = 30
        anim.layer.shadowColor = UIColor.darkGrayColor().CGColor
        anim.layer.shadowOffset = CGSizeMake(2, 2)
        anim.layer.shadowOpacity = 1
        
        self.view.addSubview(anim)
    }

    func addItem(){
        shape = CAShapeLayer();
        
        shape.frame = CGRectMake(50, 280, 50, 50);
        shape.fillColor = UIColor.clearColor().CGColor;
        shape.lineCap = kCALineCapRound;
        shape.lineWidth = 5;
        shape.strokeColor = UIColor.brownColor().CGColor;
        //     shape.backgroundColor = UIColor.blueColor().CGColor
        let path = CGPathCreateMutable();
        
        CGPathAddEllipseInRect(path, nil, shape.bounds);
        
        CGPathMoveToPoint(path, nil, 0, 0);
        CGPathAddLineToPoint(path, nil, 50, 50);
        CGPathMoveToPoint(path, nil, 0, 50);
        CGPathAddLineToPoint(path, nil, 50, 0);
        
        shape.path = path;
        
        self.view.layer.addSublayer(shape)
        
        
        let slider = UISlider()
        slider.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2 - 150, CGRectGetHeight(self.view.bounds) - 20, 300, 10)
        slider.minimumValue = 0
        slider.maximumValue = 2
        slider.addTarget(self, action: "updateDuration:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(slider)
    }
    var duration: CFTimeInterval = 1

    func updateDuration(sender:UISlider){
        duration = CFTimeInterval(sender.value)
    }
    
    func apply(sender:UIButton){
        GeneralAnimations.shared().addAnimationForLayer(shape,
            keyPath: "transform.translation.x",
            fromValue: 0,
            toValue: 400,
            duration: 0.3,
            timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
            fileMode: kCAFillModeForwards,
            autoReverse: false,
            removedOnCompleted: false) { () -> Void in
                
        }
        
    }
    func reset(sender:UIButton){
        GeneralAnimations.shared().addAnimationForLayer(shape,
            keyPath: "transform.translation.x",
            fromValue: 400,
            toValue: 0,
            duration: 0.3,
            timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
            fileMode: kCAFillModeForwards,
            autoReverse: false,
            removedOnCompleted: false) { () -> Void in
                
        }
    }
    
    var animations = [
        ["name":"scale", "value":"transform.scale"],
        ["name":"opacity", "value":"opacity"],
        ["name":"transX", "value":"transform.translation.x"],
        ["name":"transY", "value":"transform.translation.y"]]
    var animationsShowed = false
    
    var animSelections = NSMutableArray()
    
    func selectAnim(sender:UIButton){
        
        GeneralAnimations.shared().addAnimationForLayer(sender.layer,
            keyPath: "transform.scale",
            fromValue: 0.8,
            toValue:  1,
            duration: duration,
            timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
            fileMode: kCAFillModeForwards,
            autoReverse: false,
            removedOnCompleted: false,
            completion: { () -> Void in
                
        })
        
        if animationsShowed{
        
            
            for v in animSelections{
                let tmp:UIButton = v as! UIButton
                
                GeneralAnimations.shared().addAnimationForLayer(tmp.layer,
                    keyPath: "position",
                    fromValue: NSValue(CGPoint:tmp.center),
                    toValue:  NSValue(CGPoint:anim.center),
                    duration: duration,
                    timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
                    fileMode: kCAFillModeForwards,
                    autoReverse: false,
                    removedOnCompleted: false,
                    completion: { () -> Void in
                        
                })
                
                GeneralAnimations.shared().addAnimationForLayer(tmp.layer,
                    keyPath: "transform.scale",
                    fromValue: 1,
                    toValue:  0,
                    duration: duration,
                    timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
                    fileMode: kCAFillModeForwards,
                    autoReverse: false,
                    removedOnCompleted: false,
                    completion: { () -> Void in
                        tmp.removeFromSuperview()
                })
            }
            
           
            animSelections.removeAllObjects()
            
        }else{
            var off: CGFloat = 0.0
            var i :Double = 0.0
            
            let radius = 100.0
            for dic in animations{
                let a = UIButton();
                let str = dic["name"]
                var size = str!.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)])
           
                size = CGSizeMake(50, 50)
                let angle = M_PI_2 * (i++) / 3;
                let offX = cos(angle) * radius
                let offY = sin(angle) * radius
                
                off += size.width + 20
                a.frame = CGRectMake(CGRectGetMinX(sender.frame) - CGFloat(offX),
                    CGRectGetMinY(sender.frame) - CGFloat(offY),
                    size.width,
                    size.width)
              
                a.setTitle(str, forState: UIControlState.Normal)
                a.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
                a.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)

                a.titleLabel!.font = UIFont.systemFontOfSize(14)
                a.backgroundColor = UIColor.lightGrayColor()
                
                a.layer.cornerRadius = size.width / 2
//                a.layer.borderWidth = 0.5
//                
//                a.layer.borderColor = UIColor.lightGrayColor().CGColor
                a.layer.shadowColor = UIColor.darkGrayColor().CGColor
                a.layer.shadowOffset = CGSizeMake(2, 2)
                a.layer.shadowOpacity = 1
                
                self.view .addSubview(a)
                animSelections.addObject(a)
                
                GeneralAnimations.shared().addAnimationForLayer(a.layer,
                    keyPath: "position",
                    fromValue: NSValue(CGPoint:anim.center),
                    toValue:  NSValue(CGPoint:a.center),
                    duration: duration,
                    timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
                    fileMode: kCAFillModeForwards,
                    autoReverse: false,
                    removedOnCompleted: false,
                    completion: { () -> Void in
                        
                })
                
                GeneralAnimations.shared().addAnimationForLayer(a.layer,
                    keyPath: "transform.scale",
                    fromValue: 0,
                    toValue:  1,
                    duration: duration,
                    timeFunction: CAMediaTimingFunction(controlPoints: maker.x1, maker.x2, maker.y1, maker.y2),
                    fileMode: kCAFillModeForwards,
                    autoReverse: false,
                    removedOnCompleted: false,
                    completion: { () -> Void in
                        
                })
            }
        }
        
        animationsShowed = !animationsShowed
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bazerMaker(maker: BazerMaker, point1: CGPoint, point2: CGPoint) {
        
        ctrl1Label.text = String(format:"(%.2f, %.2f)", point1.x.native, point1.y.native)
        ctrl2Label.text = String(format:"(%.2f, %.2f)", point2.x.native, point2.y.native)

    }
}


