//
//  Filemanager.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

class Filemanager: NSObject {

	fileprivate func createImageCacheDirectory() {
		self.createCacheDirectory(directoryname: "image")
		self.createCacheDirectory(directoryname: "profileimage")
		self.createCacheDirectory(directoryname: "largeProfileimage")
		self.createCacheDirectory(directoryname: "messageImage")
		self.createCacheDirectory(directoryname: "messageImage/large")
		self.createCacheDirectory(directoryname: "messageImage/small")
		self.createCacheDirectory(directoryname: "notecover")
	}
	
	fileprivate func createApplicationSupportdir() {
		self.createDirectory(directoryname: "")
		self.createDirectory(directoryname: "database")
		self.createDirectory(directoryname: "image")
		self.createDirectory(directoryname: "pretest")
	}
	
	func initialSetup() {
		self.createApplicationSupportdir()
		self.createImageCacheDirectory()
	}
	
	func createDirectory(directoryname: String) {
		var path: String = ""
		let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
		path = paths[0].stringByAppendingPathComponent1(path: directoryname)
		
		if !(FileManager.default.fileExists(atPath: path)) {
			do {
				try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
			} catch let error as NSError {
				NSLog("Unable to create directory \(error.debugDescription)")
			}
			
		}
	}
	
	fileprivate func createCacheDirectory(directoryname: String) {
		var path: String = ""
		let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
		path = paths[0].stringByAppendingPathComponent1(path: directoryname)
		
		if !(FileManager.default.fileExists(atPath: path)) {
			do {
				try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
			} catch let error as NSError {
				NSLog("Unable to create directory \(error.debugDescription)")
			}
			
		}
	}
	
	static func copyDatabaseIntoDocumentsDirectory(databaseFilename: String) {
		let path = self.databaseDirectory()
		let destinationPath = path.stringByAppendingPathComponent1(path: databaseFilename)
		
		if !(FileManager.default.fileExists(atPath: destinationPath)) {
			let sourcePath = Bundle.main.resourcePath?.stringByAppendingPathComponent1(path: databaseFilename)
			do {
				try FileManager.default.copyItem(atPath: sourcePath!, toPath: destinationPath)
			} catch let error as NSError {
				NSLog("Unable to create directory \(error.debugDescription)")
			}
			
		}
	}
	
	static func databaseDirectory() -> String {
		let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
		let path = paths[0].stringByAppendingPathComponent1(path: "database")
		
		return path
	}
	
	static func renameFile(name oldName: String, toName newName: String, documentDir: String) -> Bool {
		let oldPath = documentDir.stringByAppendingPathComponent1(path: oldName)
		let newPath = documentDir.stringByAppendingPathComponent1(path: newName.stringByDeletingPathExtension).stringByAppendingPathExtension(ext: oldName.pathExtension)
		
		let fileMan = FileManager.default
		
		do {
			try fileMan.moveItem(atPath: oldPath, toPath: newPath!)
		} catch _ as NSError {
			return false
		}
		return true
	}
	
	static func getMyProfile(path: String) -> UIImage {
		let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
		let image = "\(paths[0])/image/\(path)"
		let imageData = NSData(contentsOfFile: image)
		
		return UIImage(data: imageData! as Data)!
	}
}
