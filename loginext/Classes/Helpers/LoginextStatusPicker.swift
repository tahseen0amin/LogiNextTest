//
//  LoginextStatusPicker.swift
//  loginext
//
//  Created by Tasin Zarkoob on 20/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit

class LoginextStatusPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    typealias DPPickerCompletion = (_ cancel: Bool) -> Void
    typealias DPPickerValueIndexCompletion = (_ value: String?, _ index: Int, _ cancel: Bool) -> Void
    typealias PickerCompletionBlock  = (_ cancel: Bool) -> Void
    
    static let shared = LoginextStatusPicker()
    
    private var data: [String]?
    private var alertView: UIAlertController?
    private var pickerCompletion: PickerCompletionBlock?
    
    // MARK: Main Methods
    func showPicker(in controller: UIViewController, title: String?, selected: String?, strings:[String], completion:DPPickerValueIndexCompletion?) {
        self.data = strings
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        if let value = selected {
            picker.reloadAllComponents()
            if strings.count > 0 {
                OperationQueue.current?.addOperation {
                    let index = strings.firstIndex(of: value) ?? 0
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }

        self.showPicker(title: title, view: picker, controller: controller) { (cancel) in
            var index = -1
            var value: String? = nil
            
            if !cancel, strings.count > 0 {
                index = picker.selectedRow(inComponent: 0)
                if index >= 0 {
                    value = self.data?[index]
                }
            }
            completion?(value, index, cancel || index < 0)
        }
    }
    
    // MARK: Picker View DataSource and Delegate Implementation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data?.count == 0 ? 0 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?[row]
    }
    
    // MARK: Show Alert View Controller
    private func showPicker(title: String?, view: UIView, controller: UIViewController, completion:DPPickerCompletion?) {
        let center: CGFloat = controller.view.center.x
                
        // trick
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
        alertView.view.addSubview(view)
        alertView.popoverPresentationController?.sourceView = UIViewController.top?.view
        alertView.popoverPresentationController?.sourceRect = view.bounds
        alertView.view.tintColor = .gray
        self.alertView = alertView
        
        view.center.x = center
        view.transform = .init(translationX: -10, y: title != nil ? 35 : 0)
        
        self.pickerCompletion = completion
        
        // ok button
        let ok = UIAlertAction(title: "Done", style: .default) { (action) in
            completion?(false)
        }
        alertView.addAction(ok)
        
        controller.present(alertView, animated: true, completion: nil)
    }
}

internal extension UIViewController {

    static var top: UIViewController? {
        get {
            return topViewController()
        }
    }

    static var root: UIViewController? {
        get {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
    }

    static func topViewController(from viewController: UIViewController? = UIViewController.root) -> UIViewController? {
        if let tabBarViewController = viewController as? UITabBarController {
            return topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }
    
}
