//
//  UIViewControllerExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension UIViewController {
  @objc func push(to viewController: UIViewController, animated: Bool) {
    navigationController?.pushViewController(viewController, animated: animated)
  }
  
  @objc func pop(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }
  
  @objc func present(to viewController: UIViewController, animated: Bool) {
    present(viewController, animated: animated, completion: nil)
  }
  
  class func loadFromNib() -> Self {
    func loadFromNib<T: UIViewController>(_ type: T.Type) -> T {
      return T.init(nibName: String(describing: T.self), bundle: nil)
    }
    return loadFromNib(self)
  }
}
