//
//  PhotoTools+Alert.swift
//  HXPhotoPicker
//
//  Created by Slience on 2021/9/1.
//

import UIKit

extension PhotoTools {
    
    /// 跳转系统设置界面
    static func openSettingsURL() {
        if let openURL = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(openURL)
            }
        }
    }
    
    /// 显示UIAlertController
    public static func showAlert(
        viewController: UIViewController?,
        title: String?,
        message: String? = nil,
        leftActionTitle: String?,
        leftHandler: ((UIAlertAction) -> Void)?,
        rightActionTitle: String?,
        rightHandler: ((UIAlertAction) -> Void)?
    ) {
        showAlert(
            viewController: viewController,
            title: title,
            message: message,
            leftActionTitle: leftActionTitle,
            rightActionTitle: rightActionTitle,
            leftHandler: leftHandler,
            rightHandler: rightHandler
        )
    }
    
    public static func showAlert(
        viewController: UIViewController?,
        title: String?,
        message: String? = nil,
        leftActionTitle: String? = nil,
        rightActionTitle: String? = nil,
        leftHandler: ((UIAlertAction) -> Void)? = nil,
        rightHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        guard let viewController = viewController else { return }
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if let leftActionTitle = leftActionTitle {
            let leftAction = UIAlertAction(
                title: leftActionTitle,
                style: UIAlertAction.Style.cancel,
                handler: leftHandler
            )
            alertController.addAction(leftAction)
        }
        if let rightActionTitle = rightActionTitle {
            let rightAction = UIAlertAction(
                title: rightActionTitle,
                style: UIAlertAction.Style.default,
                handler: rightHandler
            )
            alertController.addAction(rightAction)
        }
        if UIDevice.isPad {
            let pop = alertController.popoverPresentationController
            pop?.permittedArrowDirections = .any
            pop?.sourceView = viewController.view
            pop?.sourceRect = CGRect(
                x: viewController.view.width * 0.5,
                y: viewController.view.height,
                width: 0,
                height: 0
            )
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showConfirm(
        viewController: UIViewController?,
        title: String?,
        message: String?,
        actionTitle: String?,
        actionHandler: ((UIAlertAction) -> Void)?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if let view = viewController?.view, UIDevice.isPad {
            let pop = alertController.popoverPresentationController
            pop?.permittedArrowDirections = .any
            pop?.sourceView = view
            pop?.sourceRect = CGRect(
                x: view.width * 0.5,
                y: view.height,
                width: 0,
                height: 0
            )
        }
        if let actionTitle = actionTitle {
            let action = UIAlertAction(
                title: actionTitle,
                style: UIAlertAction.Style.cancel,
                handler: actionHandler
            )
            alertController.addAction(action)
            viewController?.present(
                alertController,
                animated: true
            )
        }
    }
    
    /// 显示没有相机权限弹窗
    static func showNotCameraAuthorizedAlert(
        viewController: UIViewController?,
        cancelHandler: (() -> Void)? = nil
    ) {
        guard let vc = viewController else { return }
        showAlert(
            viewController: vc,
            title: "无法使用相机功能".localized,
            message: "请前往系统设置中，允许访问「相机」。".localized,
            leftActionTitle: "取消".localized,
            rightActionTitle: "前往系统设置".localized
        ) { _ in
            cancelHandler?()
        } rightHandler: { _ in
            openSettingsURL()
        }
    }
}
