//
//  NodeMapViewController.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

class NodeMapViewController: NSViewController {
    var project: Project!
    
    @IBOutlet var mapView: NodeMapView!
    
    convenience init?(project: Project) {
        self.init(nibName: "NodeMapViewController", bundle: nil)
        self.project = project
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.mapView.rootNode = self.project.rootNode
    }    
}
