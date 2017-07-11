//
//  PokemonCollectionCell.swift
//  PoKey
//
//  Created by Vladimir Spasov on 6/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import SnapKit

class PokemonCollectionCell: UICollectionViewCell{
    var pokemonImageView: UIImageView = UIImageView()
    var pokemonName: UILabel!

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setup()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        // Border radius
        self.contentView.layer.cornerRadius  = 5
        self.contentView.layer.masksToBounds = true

        // Shadow
        self.layer.shadowColor   = UIColor.init(white: 0.5, alpha: 1).cgColor
        self.layer.shadowOffset  = CGSize(width: 0, height: 2)
        self.layer.shadowRadius  = 5
        self.layer.shadowOpacity = 0.5

        self.contentView.backgroundColor = UIColor.white

    }

    func layout() {

        contentView.addSubview(pokemonImageView)

        pokemonImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
}
