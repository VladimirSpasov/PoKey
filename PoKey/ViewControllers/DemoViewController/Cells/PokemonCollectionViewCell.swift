//
//  DemoCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Charts

import expanding_collection



class PokemonCollectionViewCell: BasePageCollectionCell {

    @IBOutlet weak var customTitle: UILabel!

    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var pokemonDescription: UILabel!

    @IBOutlet weak var statsChart: HorizontalBarChartView!



//    var statNames = [String]()

    
    override func awakeFromNib() {
        super.awakeFromNib()

        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2

        pokemonImageView.layer.borderWidth = 1
        pokemonImageView.layer.borderColor = tangerineColor().cgColor
        pokemonImageView.layer.cornerRadius = 10

        pokemonImageView.layer.shadowRadius = 10
        pokemonImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        pokemonImageView.layer.shadowOpacity = 0.2

        setupChart()
    }

    fileprivate func setupChart(){
        // Customization
        statsChart.chartDescription?.text = ""
        statsChart.noDataText = ""

        statsChart.xAxis.labelPosition = .bottom


        statsChart.leftAxis.axisMinimum = 0
        statsChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 15)
        statsChart.leftAxis.enabled = false
        statsChart.rightAxis.enabled = false

        statsChart.leftAxis.granularityEnabled = true
        statsChart.leftAxis.granularity = 1

        statsChart.xAxis.drawGridLinesEnabled = false
        statsChart.legend.enabled = false
        statsChart.scaleYEnabled = false
        statsChart.scaleXEnabled = false
        statsChart.pinchZoomEnabled = false
        statsChart.doubleTapToZoomEnabled = false
        statsChart.highlighter = nil


        statsChart.xAxis.granularity = 1

        statsChart.animate(yAxisDuration: 2.0)

        statsChart.tag = 101
    }


    func tangerineColor() -> UIColor{
        return UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
    }
}
