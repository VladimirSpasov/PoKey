//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import PokemonKit
import AlamofireImage
import Charts

import NVActivityIndicatorView

import expanding_collection 

class PokemonViewController: ExpandingViewController {

    fileprivate var cellsIsOpen = [Bool]()

    let pokemonDataSource = PokemonDataSource.sharedInstance
    fileprivate var pokemons: [PKMPokemon] = []{
        didSet{
            self.collectionView?.reloadData()
        }
    }

    fileprivate var species: [PKMPokemonSpecies] = []

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!

}

// MARK: - Lifecycle 🌎
extension PokemonViewController {

    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 335)
        super.viewDidLoad()

        pokemonDataSource.delegate = self

        registerCell()
        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let titleView = navigationItem.titleView else { return }
        let center = UIScreen.main.bounds.midX
        let diff = center - titleView.frame.midX
        titleImageViewXConstraint.constant = diff
    }

}

// MARK: Helpers
extension PokemonViewController {

    fileprivate func registerCell() {

        let nib = UINib(nibName: String(describing: PokemonCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: PokemonCollectionViewCell.self))
    }

    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: pokemons.count)
    }

    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: PokemonTableViewController = storyboard.instantiateViewController()
        return toViewController
    }

    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }

}

/// MARK: Gesture
extension PokemonViewController {

    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(PokemonViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }

        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(PokemonViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }

    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? PokemonCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            let viewController = getViewController() as! PokemonTableViewController

            viewController.chartData = chartDataWith(index: currentIndex)
            viewController.species = species[currentIndex]
            viewController.descriptionLabel.text = cell.pokemonDescription.text

            pushToViewController(viewController)
            viewController.setupChart()
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }

        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }

}

// MARK: UIScrollViewDelegate
extension PokemonViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageLabel.text = "\(currentIndex+1)/\(pokemons.count)"
    }

}

// MARK: UICollectionViewDataSource
extension PokemonViewController {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? PokemonCollectionViewCell else { return }

        let index = indexPath.row
        let info = pokemons[index]

        let spriteUrl = info.sprites?.frontDefault
        cell.pokemonImageView?.af_setImage(
            withURL: URL(string: spriteUrl!)!,
            placeholderImage: nil,
            filter: nil,
            imageTransition: .flipFromBottom(0.5)
        )


        let dataForChart = chartDataWith(stats: info.stats!)



        let format = NumberFormatter()
        format.numberStyle = .none
        format.maximumFractionDigits = 0
        let formatter = DefaultValueFormatter(formatter: format)


        cell.statsChart.rightAxis.valueFormatter = (formatter as? IAxisValueFormatter)
        cell.statsChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataForChart.0)

        cell.statsChart.data = dataForChart.1

        cell.customTitle.text = "Nº " + String(describing: info.id!) + " " + (info.name?.capitalized)!

        cell.xpLabel.text = String(describing: info.base_experience!)
        cell.heightLabel.text = String(describing: info.height!)
        cell.weightLabel.text = String(describing: info.weight!)

        cell.pokemonDescription.text = getPokemonDescription(species: species[index])


        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PokemonCollectionViewCell
            , currentIndex == indexPath.row else { return }

        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())

            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
    }

}

// MARK: UICollectionViewDataSource
extension PokemonViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PokemonCollectionViewCell.self), for: indexPath)
    }

}

extension PokemonViewController {
    func chartDataWith(index : Int) -> ([String], BarChartData){
        return chartDataWith(stats: pokemons[index].stats!)
    }
    func chartDataWith(stats: [PKMStatMas]) -> ([String], BarChartData){

        var statsEntries = [ChartDataEntry]()
        var statNames = [String]()

        var i = 0
        for stat in stats {
            let statEntry = BarChartDataEntry(x: Double(i), y: Double(stat.base_stat!))
            statsEntries.append(statEntry)

            // Append the stat to the array
            statNames.append((stat.stat?.name)!)

            i += 1
        }

        let chartDataSet = BarChartDataSet(values: statsEntries, label: "Stats")
        chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = BarChartData(dataSet: chartDataSet)

        return (statNames, chartData)
    }

    func getPokemonDescription(species: PKMPokemonSpecies) -> String{
        var pokemondDscription = ""
        for flavorText in species.flavorTextEntries!{
            if (flavorText.language?.name == "en"){
                pokemondDscription = flavorText.flavorText!
            }
        }
        let filteredDescription = pokemondDscription.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\u{c}", with: " ")
        return filteredDescription
    }
}

extension PokemonViewController: PokemonDataDelegate{
    func finishedLoading() {
        pokemons = pokemonDataSource.pokemons
        species = pokemonDataSource.species
        fillCellIsOpenArray()
        pageLabel.text = "\(currentIndex+1)/\(pokemons.count)"
    }

    func newPokemon(index: Int) {
        collectionView?.scrollToItem(at: IndexPath(row: index, section: 0) , at: .centeredHorizontally , animated: true)
    }
}
