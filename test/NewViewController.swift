//
//  NewViewController.swift
//  test
//
//  Created by zhanghao on 2019/8/20.
//  Copyright © 2019 zhanghao. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    private let animation = PushAnimation.init()
    private lazy var transitionInteractive: TransitionInteractiveAnimation = {
        let interactive = TransitionInteractiveAnimation.init()
        interactive.addScrollView(self.tableView, controller: self)
        return interactive
    }()
    private var cacheWindowColor: UIColor?// 解决 nav 动画是黑边问题。
    private let tableView = UITableView.init(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        
        let y = UIApplication.shared.statusBarFrame.height
        let navBar = UIView.init(frame: .init(x: 0, y: y, width: view.bounds.width, height: (navigationController?.navigationBar.frame.height ?? 0)))
        navBar.backgroundColor = .white
        view.addSubview(navBar)
        
        tableView.frame = .init(x: 0, y: navBar.frame.maxY, width: view.bounds.width, height: UIScreen.main.bounds.height - navBar.frame.maxY)
        let header = UIView.init(frame: UIScreen.main.bounds)
        let colors = [UIColor.red, UIColor.blue, UIColor.yellow]
        let colorViewH = header.bounds.height / CGFloat(colors.count)
        for i in 0..<colors.count {
            let view = UIView.init(frame: .init(x: 0, y: CGFloat(i) * colorViewH, width: header.bounds.width, height: colorViewH))
            view.backgroundColor = colors[i]
            header.addSubview(view)
        }
        tableView.tableHeaderView = header
        tableView.tableFooterView = .init()
        view.addSubview(tableView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        let keyWindow = UIApplication.shared.keyWindow
//        cacheWindowColor = keyWindow?.backgroundColor
//        keyWindow?.backgroundColor = view.backgroundColor
//        automaticallyAdjustsScrollViewInsets = false
        
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        DispatchQueue.main.async {
//        }
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.delegate = nil
//        UIApplication.shared.keyWindow?.backgroundColor = cacheWindowColor
    }
}

// MARK: - Public
extension NewViewController {
    
    public func setAnimationStartY(startY: CGFloat, margin: CGFloat) {
        animation.startY = startY
        animation.subMargin = margin
    }
}

extension NewViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            animation.type = .push
        } else {
            animation.type = .pop
        }
        return animation
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return transitionInteractive.isInteractive == true ? transitionInteractive : nil
    }
}

