//
//  AppDelegate.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var workspace = Workspace()
    var controllers: [MapWindowController] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        self.spawnNewDocumentWindowWithDocumentAtPath("/Users/kyb/Downloads/scan.xml")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func spawnNewDocumentWindowWithDocumentAtPath(_ path: String) {
        do {
            let p = try self.workspace.openProjectFile(path: path)
            let c = MapWindowController(project: p)
            self.controllers.append(c)
            c.showWindow(nil)
            NSDocumentController.shared().noteNewRecentDocumentURL(URL(fileURLWithPath: path))
        } catch {
            NSLog("caught \(error)")
        }
    }
}

extension AppDelegate {
    @IBAction func openDocument(_ sender: AnyObject?) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["xml"]
        
        let result = panel.runModal()
        if result == NSFileHandlingPanelCancelButton {
            return
        }
        if let fn = panel.url?.path {
            self.spawnNewDocumentWindowWithDocumentAtPath(fn)
        }
    }
}

