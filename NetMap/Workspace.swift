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
    
    func newProjectFromFile(file: String) throws -> Project {
        let parser = NmapXMLParser()
        let p = try parser.parseXMLFile(file)
        self.projects.append(p)
        return p
    }
}