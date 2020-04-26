//
//  PushAnimation.swift
//  test
//
//  Created by zhanghao on 2019/8/20.
//  Copyright © 2019 zhanghao. All rights reserved.
//

import UIKit

class PushAnimation: NSObject {
    
    enum PushAnimationType {
        case push
        case pop
    }
    
    public var type: PushAnimationType = .push
    private var transitionContext: UIViewControllerContextTransitioning?
    public var startY: CGFloat = 0
    public var subMargin: CGFloat = 0
    
}

extension PushAnimation: UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if type == .push {
            pushAnimation(transitionContext)
        } else if type == .pop {
            popAnimation(transitionContext)
        }
    }
}

// MARK: - Private
extension PushAnimation {
    
    
    private func pushAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        guard let fromController = transitionContext.viewController(forKey: .from) as? ViewController else { return }
        guard let toController = transitionContext.viewController(forKey: .to) as? NewViewController else { return }
        let fromImage = fromController.view.asImage()
        fromController.view.isHidden = true
        let fromImageView = UIImageView.init(frame: fromController.view.frame)
        fromImageView.image = fromImage
        
        // 获得容器视图
        let containView = transitionContext.containerView
        containView.addSubview(fromImageView)
        containView.addSubview(toController.view)
        
        if startY != 0 {
            
            fromImageView.frame.origin.y = startY - UIScreen.main.bounds.height + subMargin
            toController.view.frame.origin.y = startY// - subMargin
        } else {
            toController.view.frame.origin.y = UIScreen.main.bounds.height
        }
        
        toController.view.alpha = 0.5
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromImageView.frame.origin.y -= toController.view.frame.origin.y
            fromImageView.alpha = 0.5
            toController.view.frame.origin.y = 0
            toController.navigationController?.setNavigationBarHidden(true, animated: true)
            toController.view.alpha = 1
        }) { (_) in
            fromController.view.isHidden = false
            fromImageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    private func popAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        
        print("pop")
        self.transitionContext = transitionContext
        
        guard let fromController = transitionContext.viewController(forKey: .from) as? NewViewController else {
            print("fromController")
            return
        }
        guard let toController = transitionContext.viewController(forKey: .to) as? ViewController else {
            print("toController")
            return
        }
        let fromImage = fromController.view.asImage()
        fromController.view.isHidden = true
        let fromImageView = UIImageView.init(frame: fromController.view.frame)
        fromImageView.image = fromImage
        
        // 获得容器视图
        let containView = transitionContext.containerView
        containView.addSubview(fromImageView)
        containView.addSubview(toController.view)
        toController.view.frame.origin.y = -UIScreen.main.bounds.height
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromImageView.frame.origin.y = UIScreen.main.bounds.height
            toController.view.frame.origin.y = 0
            print("in animation")
        }) { (_) in
            fromController.view.isHidden = false
            fromImageView.removeFromSuperview()
            print("animation finished")
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

