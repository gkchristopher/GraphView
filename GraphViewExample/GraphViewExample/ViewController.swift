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

        graphView.maxY = 3
        graphView.minY = 0
        graphView.padding = UIEdgeInsetsMake(10, 10, 10, 10)
        graphView.data = [GraphPoint(key: "Zero", value: 0),
                          GraphPoint(key: "One", value: 1),
                          GraphPoint(key: "Four", value: 4),
                          GraphPoint(key: "Two", value: 2),
                          GraphPoint(key: "Three", value: 3)]
    }
}

