//
//  PokemonCollectionController.swift
//  PoKey
//
//  Created by Vladimir Spasov on 6/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import PokemonKit
import AlamofireImage
import SnapKit

protocol PokemonKeyboardDelegate: class{
    func nextKeyboardButtonTapped()

    func sendPokemonWithId(id: Int)
}

class PokemonCollectionView: UICollectionView {
    weak var keyboardDelegate: PokemonKeyboardDelegate?

    let cellIdentifier: String = "PokemonCollectionCell"

    let headerIdentifier: String = "headerView"
    let footerIdentifier: String = "footerView"

    var pokemons: [PKMPokemon] = []{
        didSet{
            self.reloadData()
        }
    }

    let source = PokemonDataSource.sharedInstance

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.setup()
    }

    convenience init() {
        // Layout info, Scroll Direction & Size
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 98, height: 98)

        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: 60, height: 50)

//        layout.sectionFootersPinToVisibleBounds = true
//        layout.footerReferenceSize = CGSize(width: 60, height: 50)


        self.init(frame: CGRect.zero, collectionViewLayout: layout)
        source.delegate = self
        self.pokemons = source.pokemons
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {

        self.register(PokemonCollectionCell.self, forCellWithReuseIdentifier: self.cellIdentifier)

        self.register(PokemonCollectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)

        self.dataSource = self
        self.delegate   = self

        self.backgroundColor = UIColor.white
        self.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }

    func nextKeyboardButtonTapped(){
        keyboardDelegate?.nextKeyboardButtonTapped()
    }

    func tangerineColor() -> UIColor{
        return UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
    }
}

extension PokemonCollectionView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let defaults = UserDefaults(suiteName: "group.PoKey")
        let ids = defaults?.array(forKey: "pokemonIds") as! [Int]
        return pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! PokemonCollectionCell

        let pokemonInfo = pokemons[indexPath.row]

        cell.contentView.backgroundColor = UIColor.white
        cell.pokemonImageView.layer.borderWidth = 1
        cell.pokemonImageView.layer.borderColor = tangerineColor().cgColor
        cell.pokemonImageView.layer.cornerRadius = 5

        let spriteUrl = pokemonInfo.sprites?.frontDefault
        cell.pokemonImageView.af_setImage(
            withURL: URL(string: spriteUrl!)!,
            placeholderImage: UIImage(named:"unknown"),
            filter: nil,
            imageTransition: .flipFromBottom(0.5)
        )

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

        case UICollectionElementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PokemonCollectionHeader

//            headerView.backgroundColor = UIColor.white
//
//            let nextButton = UIButton(type: .custom)
//            nextButton.frame.size = CGSize(width: 48, height: 48)
//            nextButton.center = headerView.center
//
//            let image = UIImage(named: "nextKeyboardIcon")
//            nextButton.setImage(image, for: .normal)
//
//            headerView.addSubview(nextButton)

            headerView.nextButton.addTarget(self, action: #selector(self.nextKeyboardButtonTapped), for: .touchUpInside)

//            headerView.nextButton.frame.size = CGSize(width: 48, height: 48)
//            headerView.nextButton.center = headerView.center

//            headerView.backgroundColor = UIColor.red

            return headerView

        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath)

//            footerView.backgroundColor = UIColor.green
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
}

extension PokemonCollectionView: UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemonInfo = pokemons[indexPath.row]

        keyboardDelegate?.sendPokemonWithId(id: pokemonInfo.id!)
    }
}

extension PokemonCollectionView: PokemonDataDelegate{
    func finishedLoading() {
        pokemons = source.pokemons
    }

    func newPokemon(index: Int) {
        
    }
}
