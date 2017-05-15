//
//  MainScreenTVC.swift
//  FileTestApp
//
//  Created by kanybek on 5/15/17.
//  Copyright © 2017 kanybek. All rights reserved.
//

import UIKit

class MainScreenTVC: UITableViewController {
    
    var folders: [String] = []
    
    var initialString: String?
    let companion: MainScreenCompanion
    
    convenience init() {
        self.init(initialString: nil)
    }
    
    init(initialString: String?) {
        self.initialString = initialString
        self.companion = MainScreenCompanion(someValue: 0)
        super.init(nibName: "MainScreenTVC", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MainScreenTVC deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Папки"
        let nib = UINib(nibName: "FolderTVCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "FolderTVCell")
        
        let addButton = UIBarButtonItem(
            title: "Добавить папку",
            style: .plain,
            target: self,
            action: #selector(createFolder(_:))
        )
        self.navigationItem.rightBarButtonItem = addButton
        
        
        let startMonitorButton = UIBarButtonItem(
            title: "Monitor",
            style: .plain,
            target: self,
            action: #selector(startMonitorDidPressed(_:))
        )
        self.navigationItem.leftBarButtonItem = startMonitorButton
        
        
        self.reloadAllFolders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reloadAllFolders() {
        self.folders = self.companion.getFolders()
        self.tableView.reloadData()
    }
    
    func createFolder(_ sender: UIBarButtonItem) {
        let createVC = CreateFolderVC(initialString: "")
        createVC.createFolderBlock = {[weak self] (folderName: String) -> Void in
            self?.companion.createFolder(folderName: folderName)
            self?.folders.insert(folderName, at: 0)
            self?.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self?.tableView.beginUpdates()
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            self?.tableView.endUpdates()
        }
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    func startMonitorDidPressed(_ sender: UIBarButtonItem) {
        
        if let folderPath = self.folders.last {
            
            let folderName = self.companion.nameForPath(path: folderPath)
            
            let alert: UIAlertController = UIAlertController(title: "Старт мониторить папку",
                                                             message: "Начинаем мониторить \(folderName)",
                                                             preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Начать", style: .default, handler: {
                (UIAlertAction) -> Void in
                
                let date = Date(timeIntervalSinceNow:2*60)
                let notification = UILocalNotification()
                notification.fireDate = date
                notification.alertTitle = "Reminder"
                notification.alertBody = "Car Wash : Take Car to garage"
                notification.repeatInterval = NSCalendar.Unit.hour
                UIApplication.shared.scheduleLocalNotification(notification)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Пусто",
                                                             message: "",
                                                             preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTVCell", for: indexPath) as! FolderTVCell
        let folderPath = self.folders[indexPath.row]
        cell.textLabel?.text = self.companion.nameForPath(path: folderPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folderPath_ = self.folders[indexPath.row]
            self.companion.deleteFolder(folderPath: folderPath_)
            self.folders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let folderPath_ = self.folders[indexPath.row]
        let filesTVC = TextFilesListTVC(initialFolderPath: folderPath_)
        self.navigationController?.pushViewController(filesTVC, animated: true)
    }
}
