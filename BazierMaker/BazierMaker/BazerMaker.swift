//
//  BazerMakerControlView.swift
//  BazierMaker
//
//  Created by sunlantao on 15/4/11.
//  Copyright (c) 2015年 sunlantao. All rights reserved.
//

import UIKit

class Coordination : NSObject {
    class func coord(orgin:CGPoint!, x:CGFloat, y :CGFloat)->CGPoint{
        return CGPoint(x: orgin.x + x, y:orgin.y - y);
    }
    
    class func coord(layer:CALayer!, x:CGFloat, y:CGFloat)->CGPoint {
        return CGPoint(x: CGRectGetWidth(layer.bounds) * x, y: CGRectGetHeight(layer.bounds) * (1 - y))
    }
    class func reCoord(layer:CALayer!, x:CGFloat, y:CGFloat)->CGPoint {
        return CGPoint(x: x/CGRectGetWidth(layer.bounds) , y: (1 - (y / CGRectGetHeight(layer.bounds)) ))
    }
}

protocol BazerMakeDelege : NSObjectProtocol {
    
    func bazerMaker(maker: BazerMaker, point1:CGPoint, point2:CGPoint)
}

class BazerMaker: UIView{

    /*区域layer*/
    var canvas : CAShapeLayer!
    var bezier:CAShapeLayer!
    var control:CAShapeLayer!

    var coordReference:CGPoint = CGPointZero{
        didSet{
            makeLayout();
        }
    }
    var coordSize:CGSize = CGSizeMake(200, 200){
        didSet{
            makeLayout();
        }
    }

    
    var ctrl1:CGPoint!
    var ctrl2:CGPoint!
    
    var delegate: BazerMakeDelege?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.makeLayout();
    }
    
    var shape:CAShapeLayer!
  
    func makeLayout() {
        
        if canvas != nil{
            for layer in canvas.sublayers{
                layer.removeFromSuperlayer();
            }
        }else{
            //添加画布区域
            canvas = CAShapeLayer();
            canvas.frame = self.bounds;
            canvas.backgroundColor = UIColor(red: 109/255.0, green: 199/255.0, blue: 1, alpha: 1.0).CGColor;
            canvas.fillColor = UIColor.clearColor().CGColor
            canvas.strokeColor = UIColor.blueColor().CGColor;
            self.layer.addSublayer(canvas);
        }
        
        //添加控制区域-两条控制线的位置
        control = CAShapeLayer();
        control.frame = CGRectMake(0, 0, coordSize.width, coordSize.height);
        control.fillColor = UIColor.clearColor().CGColor
        control.strokeColor = UIColor.redColor().CGColor
        control.anchorPoint = CGPoint(x:0, y : 1);
        control.position = coordReference;
    
        var path = UIBezierPath();
        
        control.path = path.CGPath
        
        canvas.addSublayer(control);

        
        var array = ["0.0", "0.25", "0.5", "0.75", "1.0"]
        
        //添加刻度
        for (var i :Int = 0; i < 5; i++){
            var mark = CATextLayer();
            
            var attrString = NSMutableAttributedString(string: array[i]);

            attrString.addAttribute(
                kCTForegroundColorAttributeName as String,
                value: UIColor.whiteColor().colorWithAlphaComponent(0.6),
                range: NSMakeRange(0, attrString.length))
            
            mark.string = attrString;
            
            var tmp = Double(i) / 4.0;
            var x = CGRectGetWidth(control.bounds) * CGFloat(tmp);
            var p = Coordination.coord(coordReference, x: x, y: 0)
            mark.frame = CGRectMake(p.x, p.y, 30, 20);
            
            mark.font = UIFont.smallSystemFontSize();
            mark.contentsScale = 4;
            canvas.addSublayer(mark);
        }
        
        for (var i :Int = 1; i < 5; i++){
            var mark = CATextLayer();
            
            var attrString = NSMutableAttributedString(string: array[i]);
            
            attrString.addAttribute(
                kCTForegroundColorAttributeName as String,
                value: UIColor.whiteColor().colorWithAlphaComponent(0.6),
                range: NSMakeRange(0, attrString.length))
            
            mark.string = attrString;
            
            var tmp = Double(i) / 4.0;
            var p = Coordination.coord(coordReference, x: 0, y: CGRectGetHeight(control.bounds) * CGFloat(tmp))
            
            mark.alignmentMode = kCAAlignmentRight
            mark.frame = CGRectMake(p.x - 30, p.y, 30, 20)
            mark.font = UIFont.smallSystemFontSize()
            mark.contentsScale = 4;
            canvas.addSublayer(mark)
        }
        
        //曲线图层
        
        bezier = CAShapeLayer();
        bezier.frame = CGRectMake(0, 0, coordSize.width, coordSize.height);
        bezier.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.15).CGColor;
        bezier.fillColor = UIColor.clearColor().CGColor
        bezier.strokeColor = UIColor.blueColor().CGColor
        bezier.anchorPoint = CGPoint(x:0, y : 1);
        bezier.position = coordReference
        
        canvas.addSublayer(bezier);
        
        
        path = UIBezierPath();
        
        path.moveToPoint(Coordination.coord(bezier, x: 0, y: 0));
        
        ctrl1 = Coordination.coord(bezier, x: 0, y: 0)
        ctrl2 = Coordination.coord(bezier, x: 1, y: 1)
        
        path.addCurveToPoint(Coordination.coord(bezier, x: 1, y: 1), controlPoint1: ctrl1, controlPoint2:ctrl2);
        
        bezier.path = path.CGPath
        
        var pin = UIPanGestureRecognizer(target: self, action:"pan:")
        
        self.addGestureRecognizer(pin)
    }
    
    
    var x1 : Float = 0
    var y1 : Float = 0
    var x2 : Float = 1
    var y2 : Float = 1
    
    func apply(sender:UIButton){
    
        GeneralAnimations.shared().addAnimationForLayer(shape,
            keyPath: "transform.translation.x",
            fromValue: 0,
            toValue: 400,
            duration: 0.5,
            timeFunction: CAMediaTimingFunction(controlPoints: x1, y1, x2, y2),
            fileMode: kCAFillModeForwards,
            autoReverse: false,
            removedOnCompleted: false) { () -> Void in
        }
    }
    
    var location:CGPoint!
    var leftPressed:Bool!
    func pan(gesture:UIGestureRecognizer){
        
        switch gesture.state{
            
        case UIGestureRecognizerState.Began:
            location = gesture.locationInView(self)
            
            leftPressed = location.x < CGRectGetWidth(self.bounds)/2
            break;
        case UIGestureRecognizerState.Changed:
            
            var changed = gesture.locationInView(self)
            if (leftPressed == true){
                ctrl1 = CGPoint(x: ctrl1.x + (changed.x - location.x) / 2, y: ctrl1.y + (changed.y - location.y)/2)
            }
            else{
                ctrl2 = CGPoint(x: ctrl2.x + (changed.x - location.x) / 2, y: ctrl2.y + (changed.y - location.y)/2)
            }
            location = changed
            
            updateCurv();
            
            break;
        case UIGestureRecognizerState.Ended:
            
            break;
        default:
            break;
        }
    }
    
    //更新曲线
    func updateCurv(){
        
        var path = UIBezierPath();
        
        path.moveToPoint(Coordination.coord(bezier, x: 0, y: 0));
        
        path.addCurveToPoint(Coordination.coord(bezier, x: 1, y: 1), controlPoint1: ctrl1, controlPoint2:ctrl2);
        
        bezier.path = path.CGPath
        
        path = UIBezierPath();
        
        path.moveToPoint(Coordination.coord(control, x: 0, y: 0));
        path.addLineToPoint(ctrl1)
        
        path.moveToPoint(Coordination.coord(control, x: 1, y: 1));
        path.addLineToPoint(ctrl2)
        
        control.path = path.CGPath
        
        //传给delegate
        
        var tmp1 = Coordination.reCoord(bezier, x: ctrl1.x, y: ctrl1.y)
        x1 = Float(tmp1.x)
        y1 = Float(tmp1.y)
        
        var tmp2 = Coordination.reCoord(bezier, x: ctrl2.x, y: ctrl2.y)
        x2 = Float(tmp2.x)
        y2 = Float(tmp2.y)
        
        delegate?.bazerMaker(self, point1: CGPointMake(tmp1.x, tmp1.y), point2:CGPointMake(tmp2.x, tmp2.y))
        
    }
    
    
}
