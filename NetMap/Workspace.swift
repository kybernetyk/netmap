//
//  Workspace.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation

class Workspace {
    var projects: [Project] = []
    
    func newProjectFromFile(file: String) -> Project? {
        let parser = NmapXMLParser()
        
        guard let p = parser.parseXMLFile(file) else {
            NSLog("failed to load \(file) ...")
            return nil
        }
        self.projects.append(p)
        return p
    }
}