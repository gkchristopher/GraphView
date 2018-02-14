//
//  ViewController.swift
//  GraphViewExample
//
//  Created by Christopher J Moore on 2/14/18.
//  Copyright © 2018 Roving Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var graphView: GraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.maxY = 4
        graphView.minY = 0
        graphView.padding = UIEdgeInsetsMake(10, 10, 50, 10)
        graphView.data = [("Zero", 0), ("One", 1), ("Four", 4), ("Two", 2), ("Three", 3)]
    }
}

