//
//  TransitionInteractiveAnimation.swift
//  test
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019 zhanghao. All rights reserved.
//

import UIKit

class TransitionInteractiveAnimation: UIPercentDrivenInteractiveTransition {
    
    public var isInteractive = false
    private var controller: UIViewController?
    private var delegate: UIScrollViewDelegate?
    private var isBeginDragging = false
    private var isDraging = false
    private let limitOffset: CGFloat = 20
    private var startY: CGFloat = 0
    
    public func addScrollView(_ scrollView: UIScrollView, controller: UIViewController) {

        cacheDelegate(scrollView)
        self.controller = controller
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "delegate", options: .new, context: nil)
    }
    
//    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
//        print("asdkjladjkla")
//        super.startInteractiveTransition(transitionContext)
////        DispatchQueue.main.async {
////            self.finish()
////        }
//        finish()
////        abs(offsetY) > limitOffset ? finish() : cancel()
//        print("aakljsdajklddsaljk")
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = object as? UIScrollView else { return }
        switch keyPath {
        case "contentOffset":
            
            guard let contentOffset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else { return }
            let offsetY = contentOffset.y
//            print(offsetY)
            if offsetY < 0 {
                    
                handlePull(offsetY: offsetY)
            }
        case "delegate":
            cacheDelegate(scrollView)
        default:
            break
        }
    }
}

// MARK: - Private
extension TransitionInteractiveAnimation {
    
    private func cacheDelegate(_ scrollView: UIScrollView) {
        self.delegate = scrollView.delegate
        scrollView.delegate = self
    }
    
    private func handlePull(offsetY: CGFloat) {
        
        guard isBeginDragging == false else {
            // 开始
            isBeginDragging = false
            isInteractive = true
            controller?.navigationController?.popViewController(animated: true)
            print("开始")
            return
        }
        
        let percentComplete = abs(offsetY) / UIScreen.main.bounds.height
        
        guard isDraging else {
            // 松手了
            isInteractive = false
//            percentComplete >= 0.2 ? finish() : cancel()
            abs(offsetY) > limitOffset ? finish() : cancel()
            print("松手了")
            return
        }
        
        // 更新进度
        update(percentComplete)
        print("更新进度\(percentComplete)")
    }
}

extension TransitionInteractiveAnimation {
    
    private func _scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isBeginDragging = true
        isDraging = true
    }
    
    private func _scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDraging = false
        let offset = scrollView.contentOffset
        scrollView.contentOffset = offset
    }
    
    private func _scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}

extension TransitionInteractiveAnimation: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
        _scrollViewWillBeginDragging(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        _scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        _scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

