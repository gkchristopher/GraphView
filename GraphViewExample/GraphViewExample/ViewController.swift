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
        graphView.labelFillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        graphView.lineLabelColor = .black

        graphView.maxY = 5
        graphView.minY = 0
        graphView.padding = UIEdgeInsetsMake(20, 20, 20, 20)
        graphView.data = [GraphPoint(label: "0", value: 0, axisLabel: NSAttributedString(string: "1")),
                          GraphPoint(label: "1", value: 1, axisLabel: NSAttributedString(string: "2")),
                          GraphPoint(label: "4", value: 4, axisLabel: NSAttributedString(string: "3")),
                          GraphPoint(label: "3", value: 3, axisLabel: NSAttributedString(string: "4")),
                          GraphPoint(label: "1", value: 1, axisLabel: NSAttributedString(string: "5")),
                          GraphPoint(label: "5", value: 5, axisLabel: NSAttributedString(string: "6")),
                          GraphPoint(label: "1", value: 1, axisLabel: NSAttributedString(string: "7")),
                          GraphPoint(label: "3", value: 3, axisLabel: NSAttributedString(string: "8")),
                          GraphPoint(label: "2", value: 2, axisLabel: NSAttributedString(string: "9")),
                          GraphPoint(label: "1", value: 1, axisLabel: NSAttributedString(string: "10")),
                          GraphPoint(label: "4", value: 4, axisLabel: NSAttributedString(string: "11"))]
    }
}

