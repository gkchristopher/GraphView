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

        graphView.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        graphView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

        graphView.maxY = 5
        graphView.minY = 0
        graphView.padding = UIEdgeInsetsMake(20, 20, 20, 20)
        graphView.data = [GraphPoint(key: "Zero", value: 0),
                          GraphPoint(key: "One", value: 1),
                          GraphPoint(key: "Four", value: 4),
                          GraphPoint(key: "Two", value: 2),
                          GraphPoint(key: "Five", value: 5),
                          GraphPoint(key: "Two", value: 2),
                          GraphPoint(key: "Two", value: 2),
                          GraphPoint(key: "One", value: 1),
                          GraphPoint(key: "Two", value: 2),
                          GraphPoint(key: "Three", value: 3)]
    }
}

