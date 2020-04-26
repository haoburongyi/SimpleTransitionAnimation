//
//  ViewController.swift
//  test
//
//  Created by zhanghao on 2019/8/15.
//  Copyright © 2019 zhanghao. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit

class ViewController: UIViewController {
    
    private let tableView = UITableView.init(frame: .zero, style: .plain)
    private let pullStyleLabel = UILabel.init()
    private let limitOffset: CGFloat = 20
    private var enterNextController = false {
        didSet {
            if enterNextController {
                pullStyleLabel.text = "松手进入下一页"
            } else {
                pullStyleLabel.text = "上拉进入下一页"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .blue
        title = "sjkfdfjlkasfkljsfj"
        navigationController?.navigationBar.isTranslucent = false
        
        let whiteView = UIView.init(frame: .init(x: 0, y: 400, width: view.bounds.width, height: 100))
        whiteView.backgroundColor = .white
//        view.addSubview(whiteView)
        tableView.frame = view.bounds
        let header = UIView.init(frame: view.bounds)
//        let topHeight = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
//        header.frame.size.height -= topHeight
//        tableView.frame.size.height -= topHeight
        header.addSubview(whiteView)
        header.backgroundColor = .groupTableViewBackground
        tableView.tableHeaderView = header
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
//        tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        pullStyleLabel.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 50)
        pullStyleLabel.text = "上拉进入下一页"
        pullStyleLabel.textAlignment = .center
        pullStyleLabel.textColor = .blue
        tableView.tableFooterView = pullStyleLabel
//        tableView.addSubview(pullStyleLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controller = NewViewController()
        navigationController?.delegate = controller
        //            controller.
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        guard keyPath == "contentOffset" else {
//            return
//        }
//        guard let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else {
//            return
//        }
//
//
//    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetY = scrollView.contentOffset.y
        let maxOffset = tableView.contentSize.height - tableView.bounds.height
        enterNextController = offSetY >= maxOffset + limitOffset
//        print(offSetY)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if enterNextController {
            let controller = NewViewController()
            navigationController?.delegate = controller
            let footer = tableView.tableFooterView ?? UIView.init()
            let startY = footer.convert(footer.frame.origin, to: view).y - UIScreen.main.bounds.height + footer.frame.size.height
            let maxOffset = tableView.contentSize.height - tableView.bounds.height
            controller.setAnimationStartY(startY: startY, margin: scrollView.contentOffset.y - maxOffset - limitOffset)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
      
    }
}
