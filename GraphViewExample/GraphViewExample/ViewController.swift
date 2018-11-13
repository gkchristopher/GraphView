//
//  ViewController.swift
//  GraphViewExample
//
//  Created by Christopher J Moore on 2/14/18.
//  Copyright © 2018 Roving Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var points = [CGFloat]()

    @IBOutlet var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        points = (0..<10).map { _ in CGFloat.random(in: 0.0...1.0) }

        graphView.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        graphView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        graphView.labelFillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        graphView.gridLineColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)

        graphView.padding = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension ViewController: GraphViewDataSource {

    func numberOfPoints(in graphView: GraphView) -> Int {
        return points.count
    }
    
    func graphView(_ graphView: GraphView, valueAt index: Int) -> CGFloat {
        return points[index]
    }
}
