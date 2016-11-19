//
//  MapWindowController.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

class MapWindowController: NSWindowController {
    var project: Project!
    var mapViewController: NodeMapViewController!

    @IBOutlet var anchorForMapView: NSView!
}

//MARK: - inits
extension MapWindowController {
    convenience init(project: Project) {
        self.init(windowNibName: "MapWindowController")
        self.project = project
        self.project.applyFilter(f: DefaultFilters.interestingPorts)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.title = "NetMap - \(self.project.representedFile)"
        
        self.mapViewController = NodeMapViewController(project: self.project)
        self.addControllerToAnchor(self.mapViewController, anchor: self.anchorForMapView)
    }
    
    func addControllerToAnchor(_ controller: NSViewController, anchor: NSView) {
        controller.view.frame = anchor.bounds
        anchor.addSubview(controller.view)
    }
}
