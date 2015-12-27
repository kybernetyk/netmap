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
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        do {
            let p = try self.workspace.newProjectFromFile("/Users/kyb/Downloads/scan.xml")
            let c = MapWindowController(project: p)
            self.controllers.append(c)
            c.showWindow(nil)
        } catch {
            NSLog("caught \(error)")
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
}

