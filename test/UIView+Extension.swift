//
//  UIView+Extension.swift
//  test
//
//  Created by zhanghao on 2019/8/23.
//  Copyright © 2019 zhanghao. All rights reserved.
//

import UIKit

extension UIView {
    
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
//    func asSnapshotImage(afterScreenUpdates: Bool) -> UIImage {
//        return snapshotView(afterScreenUpdates: afterScreenUpdates)
//    }
}
