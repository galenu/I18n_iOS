//
//  ContentViewController.swift
//  i18n_Example
//
//  Created by gavin on 2023/10/31.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        label.i18n.text = "test_text".localized(args: ["5"])
        
        button.i18n.setTitle(.init("test_text"), forState: .normal)
        
        textField.i18n.text = .init("test_text")
        
        textView.i18n.text = .init("test_text")
        
    }
}
