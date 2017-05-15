//
//  ReadFileVC.swift
//  FileMTestApp
//
//  Created by kanybek on 5/15/17.
//  Copyright © 2017 kanybek. All rights reserved.
//

import UIKit

class ReadFileVC: UIViewController {

    var fileContent: String?
    
    @IBOutlet weak var textView: UITextView!
    
    convenience init() {
        self.init(fileContent: nil)
    }
    
    init(fileContent: String?) {
        self.fileContent = fileContent
        super.init(nibName: "ReadFileVC", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ReadFileVC deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let content_ = self.fileContent {
            self.textView.text = content_
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
