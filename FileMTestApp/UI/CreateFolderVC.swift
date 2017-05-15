//
//  CreateFolderVC.swift
//  FileTestApp
//
//  Created by kanybek on 5/15/17.
//  Copyright © 2017 kanybek. All rights reserved.
//

import UIKit

class CreateFolderVC: UIViewController {
    
    var createFolderBlock : ((String) -> Void)?
    @IBOutlet weak var textFiled: UITextField!
    
    var initialString: String?
    
    convenience init() {
        self.init(initialString: nil)
    }
    
    init(initialString: String?) {
        self.initialString = initialString
        super.init(nibName: "CreateFolderVC", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CreateFolderVC deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Новая папка"
        let events: [(Selector, UIControlEvents)] = [(#selector(CreateFolderVC.textChanged(textField:)), .editingChanged),
                                                     (#selector(CreateFolderVC.editingDidBegin(textField:)), .editingDidBegin),
                                                     (#selector(CreateFolderVC.editingDidEnd(textField:)), .editingDidEnd)]
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
    
    @IBAction func createDidPressed(_ sender: UIButton) {
        if let _initialString = self.initialString {
            if _initialString.characters.count > 0 {
                if let createBlock = self.createFolderBlock {
                    createBlock(_initialString)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    dynamic func editingDidBegin(textField: UITextField) {
    }
    
    dynamic func editingDidEnd(textField: UITextField) {
    }
}
