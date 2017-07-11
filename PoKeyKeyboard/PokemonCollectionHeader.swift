//
//  HeaderCollectionView.swift
//  PoKey
//
//  Created by Vladimir Spasov on 7/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import SnapKit

class PokemonCollectionHeader: UICollectionReusableView{

    let nextButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setup()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)!
        setup()
        layout()
    }

    func setup() {
        self.backgroundColor = UIColor.white
        let image = UIImage(named: "nextKeyboardIcon")
        nextButton.setImage(image, for: .normal)

        self.addSubview(nextButton)
    }

    func layout(){
        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 48, height: 48))
        }

        nextButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }


}
