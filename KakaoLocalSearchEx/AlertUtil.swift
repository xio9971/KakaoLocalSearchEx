//
//  AlertUtil.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/07/06.
//

import Foundation

class AlertUtil {
    
    static func showSimpleAlert(view: UIViewController,
                          title: String,
                          desc: String,
                          buttonText: String,
                          handler: ((UIAlertAction) -> Void)?,
                          cancelButtonText: String,
                          cancelHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: buttonText, style: .default, handler: handler)
        alert.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: cancelButtonText, style: cancelHandler == nil ? .cancel : .default, handler: cancelHandler)
        alert.addAction(cancelAction)
        view.present(alert, animated: true, completion: nil)
    }
        
        
}
