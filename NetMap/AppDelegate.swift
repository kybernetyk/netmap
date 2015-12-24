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
        guard let p = self.workspace.newProjectFromFile("/Users/kyb/Downloads/scan.xml") else {
            NSLog("fail!")
            return
        }
        let c = MapWindowController(project: p)
        self.controllers.append(c)
        
        c.showWindow(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

