//
//  MainScreenCompanion.swift
//  FileMTestApp
//
//  Created by kanybek on 5/15/17.
//  Copyright © 2017 kanybek. All rights reserved.
//

import UIKit

let defaultFolderPath: String = "FileTestApp"

class MainScreenCompanion {
    
    var someValue: UInt64
    
    convenience init() {
        self.init(someValue: 0)
    }
    
    init(someValue: UInt64) {
        self.someValue = someValue
    }
    
    deinit {
        print("MainScreenTVC deallocated")
    }
    
    func getFolders() -> [String] {
        var arrayOfFolderPaths: [String] = []
        if let arrayOfFolderPaths_ = FCFileManager.listDirectoriesInDirectory(atPath: defaultFolderPath) {
            for folderPath in arrayOfFolderPaths_ {
                if let folderPath_ = folderPath as? String {
                    arrayOfFolderPaths.append(folderPath_)
                }
            }
        }
        return arrayOfFolderPaths
    }
    
    func createFolder(folderName: String) -> Void {
        FCFileManager.createDirectories(forPath:(defaultFolderPath + "/" + folderName))
    }
    
    func deleteFolder(folderPath: String) -> Void {
        let folderName = self.nameForPath(path: folderPath)
        FCFileManager.removeItem(atPath: (defaultFolderPath + "/" + folderName))
    }
    
    func nameForPath(path: String) -> String {
        if let folderName_ = path.components(separatedBy: "/").last {
            return folderName_
        }
        return ""
    }
    
    func createFile(folderName: String,
                    fileName: String,
                    fileContent: String) {
        FCFileManager.createFile(atPath: (defaultFolderPath + "/" + folderName + "/" + fileName + ".txt"),
                                 withContent: fileContent as NSObject)
    }
    
    func getFilesFor(folderName: String) -> [String] {
        var arrayOfFilePath: [String] = []
        if let arrayOfFilePath_ = FCFileManager.listFilesInDirectory(atPath: (defaultFolderPath + "/" + folderName)) {
            for filePath in arrayOfFilePath_ {
                if let filePath_ = filePath as? String {
                    arrayOfFilePath.append(filePath_)
                }
            }
        }
        return arrayOfFilePath
    }
    
    func readFileAt(folderName: String,
                    fileName: String) -> String {
        if let fileContent_ = FCFileManager.readFile(atPath: (defaultFolderPath + "/" + folderName + "/" + fileName)) {
            return fileContent_
        }
        return "Empty"
    }
}
