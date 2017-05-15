//
//  TextFilesListTVC.swift
//  FileMTestApp
//
//  Created by kanybek on 5/15/17.
//  Copyright © 2017 kanybek. All rights reserved.
//

import UIKit

class TextFilesListTVC: UITableViewController {

    let companion: MainScreenCompanion
    var textFiles: [String] = []

    var initialFolderPath: String?
    convenience init() {
        self.init(initialFolderPath: nil)
    }
    
    init(initialFolderPath: String?) {
        self.initialFolderPath = initialFolderPath
        self.companion = MainScreenCompanion(someValue: 0)
        super.init(nibName: "TextFilesListTVC", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TextFilesListTVC deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let initialFolderPath_ = self.initialFolderPath {
            let title = self.companion.nameForPath(path: initialFolderPath_)
            self.title = title
        }
        
        let nib = UINib(nibName: "FolderTVCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "FolderTVCell")
        
        let addButton = UIBarButtonItem(
            title: "Добавить файл",
            style: .plain,
            target: self,
            action: #selector(createFile(_:))
        )
        self.navigationItem.rightBarButtonItem = addButton
        self.reloadAllFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reloadAllFile() {
        if let initialFolderPath_ = self.initialFolderPath {
            let folderName_ = self.companion.nameForPath(path: initialFolderPath_)
            self.textFiles = self.companion.getFilesFor(folderName: folderName_)
            self.tableView.reloadData()
        }
    }
    
    func createFile(_ sender: UIBarButtonItem) {
        let createFileVC = CreateFileVC(initialString: nil)
        createFileVC.createFileBlock = {[weak self] (fileName: String, fileContent: String) -> Void in
            if let strongSelf = self {
                if let initialFolderPath_ = strongSelf.initialFolderPath {
                    let folderName_ = strongSelf.companion.nameForPath(path: initialFolderPath_)
                    
                    strongSelf.companion.createFile(folderName:folderName_,
                                                    fileName: fileName,
                                                    fileContent: fileContent)
                    
                    strongSelf.textFiles.insert((fileName + ".txt"), at: 0)
                    strongSelf.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    strongSelf.tableView.beginUpdates()
                    strongSelf.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                    strongSelf.tableView.endUpdates()
                }
            }
        }
        self.navigationController?.pushViewController(createFileVC, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.textFiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTVCell", for: indexPath) as! FolderTVCell
        let filePath = self.textFiles[indexPath.row]
        cell.textLabel?.text = self.companion.nameForPath(path: filePath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.textFiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let initialFolderPath_ = self.initialFolderPath {
            let folderName_ = self.companion.nameForPath(path: initialFolderPath_)
            let filePath = self.textFiles[indexPath.row]
            let fileName_ = self.companion.nameForPath(path: filePath)
            
            let fileContent = self.companion.readFileAt(folderName: folderName_, fileName: fileName_)
            let readFileVC = ReadFileVC(fileContent: fileContent)
            
            self.navigationController?.pushViewController(readFileVC, animated: true)
        }
        
        
    }
}
