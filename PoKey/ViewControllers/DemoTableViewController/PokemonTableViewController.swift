//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Charts
import PokemonKit
import expanding_collection

class PokemonTableViewController: ExpandingTableViewController {

    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        let image1 = Asset.backgroundImage.image
        tableView.backgroundView = UIImageView(image: image1)
    }

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!


    @IBOutlet weak var statChartView: HorizontalBarChartView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var generaLabel: UILabel!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var habitatLabel: UILabel!
    @IBOutlet weak var happinessLabel: UILabel!
    @IBOutlet weak var growthRateLabel: UILabel!
    
    var species: PKMPokemonSpecies? = nil
    var chartData = ([String](), BarChartData())
}

// MARK: - Lifecycle
extension PokemonTableViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.backgroundView?.layer.shadowRadius = 2
        tableView.backgroundView?.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableView.backgroundView?.layer.shadowOpacity = 0.2

        headerHeight = 175
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let titleView = navigationItem.titleView else { return }
        let center = UIScreen.main.bounds.midX
        let diff = center - titleView.frame.midX
        titleImageViewXConstraint.constant = diff

        setupViews()
    }

    func setupViews(){
        headerHeight = 175



        generaLabel.text = species?.genera?[0].genus
        generationLabel.text = species?.generation?.name
        shapeLabel.text = species?.shape?.name
        colorLabel.text = species?.color?.name
        habitatLabel.text = species?.habitat?.name
        happinessLabel.text = String(describing: (species?.baseHappiness)!)
        growthRateLabel.text = species?.growthRate?.name
    }
}

// MARK: Helpers
extension PokemonTableViewController {

    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}

// MARK: Actions
extension PokemonTableViewController {

    @IBAction func backButtonHandler(_ sender: AnyObject) {
        // buttonAnimation
        let viewControllers: [PokemonViewController?] = navigationController?.viewControllers.map { $0 as? PokemonViewController } ?? []

        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate
extension PokemonTableViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //    if scrollView.contentOffset.y < -25 {
        //      // buttonAnimation
        //      let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        //
        //      for viewController in viewControllers {
        //        if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        //          rightButton.animationSelected(false)
        //        }
        //      }
        //      popTransitionAnimation()
        //    }
        
        scrollOffsetY = scrollView.contentOffset.y
    }
}

extension PokemonTableViewController{
    func setupChart(){
        // Customization

        let format = NumberFormatter()
        format.numberStyle = .none
        format.maximumFractionDigits = 0
        let formatter = DefaultValueFormatter(formatter: format)


        statChartView.rightAxis.valueFormatter = (formatter as? IAxisValueFormatter)
        statChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:chartData.0)

        statChartView.data = chartData.1

        statChartView.chartDescription?.text = ""
        statChartView.noDataText = ""

        statChartView.xAxis.labelPosition = .bottom


        statChartView.leftAxis.axisMinimum = 0
        statChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 15)
        statChartView.leftAxis.enabled = false
        statChartView.rightAxis.enabled = false

        statChartView.leftAxis.granularityEnabled = true
        statChartView.leftAxis.granularity = 1

        statChartView.xAxis.drawGridLinesEnabled = false
        statChartView.legend.enabled = false
        statChartView.scaleYEnabled = false
        statChartView.scaleXEnabled = false
        statChartView.pinchZoomEnabled = false
        statChartView.doubleTapToZoomEnabled = false
        statChartView.highlighter = nil
        
        
        statChartView.xAxis.granularity = 1
        
        statChartView.animate(yAxisDuration: 2.0)
    }
}



