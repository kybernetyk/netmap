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
    
    func openProjectFile(path: String) throws -> Project {
        //TODO: look up self.project if file already opened ...
        let parser = NmapXMLParser()
        let p = try parser.parseXMLFile(path)
        self.projects.append(p)
        return p
    }
}
