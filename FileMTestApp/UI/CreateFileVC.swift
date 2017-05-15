//
//  CreateFileVC.swift
//  FileMTestApp
//
//  Created by kanybek on 5/15/17.
//  Copyright © 2017 kanybek. All rights reserved.
//

import UIKit

class CreateFileVC: UIViewController {
    
    var createFileBlock : ((String, String) -> Void)?
    
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var initialString: String?
    
    convenience init() {
        self.init(initialString: nil)
    }
    
    init(initialString: String?) {
        self.initialString = initialString
        super.init(nibName: "CreateFileVC", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CreateFileVC deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Новый файл"
        let events: [(Selector, UIControlEvents)] = [(#selector(CreateFileVC.textChanged(textField:)), .editingChanged)]
        events.forEach {
            self.textFiled.addTarget(self, action: $0.0, for: $0.1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    dynamic func textChanged(textField: UITextField) {
        if (self.textFiled.text?.characters.count)! > 0 {
            if let text = self.textFiled.text {
                print("text is:\(text)")
                self.initialString = text
            }
        } else {
            print("text is empty")
        }
    }
    
    @IBAction func createFileDidPressed(_ sender: UIButton) {
        if let _initialString = self.initialString {
            if _initialString.characters.count > 0 {
                if let createFileBlock = self.createFileBlock {
                    createFileBlock(_initialString, self.textView.text)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
