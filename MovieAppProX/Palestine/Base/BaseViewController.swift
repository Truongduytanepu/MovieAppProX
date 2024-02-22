//
//  BaseViewController.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import Combine

class BaseViewController: UIViewController, ViewProtocol {
  var subscriptions = [AnyCancellable]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    addComponents()
    setConstraints()
    setProperties()
    binding()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setColor()
  }
  
  func addComponents() {}
  
  func setConstraints() {}
  
  func setProperties() {}
  
  func setColor() {}
  
  func binding() {}
}
