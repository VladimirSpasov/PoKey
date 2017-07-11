//
//  KeyboardViewController.swift
//  PoKeyKeyboard
//
//  Created by Vladimir Spasov on 6/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import SnapKit


class KeyboardViewController: UIInputViewController {

//    @IBOutlet var nextKeyboardButton: UIButton!

    let collectionView: PokemonCollectionView = PokemonCollectionView()



    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()

        collectionView.reloadData()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        collectionView.updateConstraints()
//        collectionView.layoutSubviews()
//    }

    func setup(){
//        // Perform custom UI setup here
//        self.nextKeyboardButton = UIButton(type: .system)
//
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//
//        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        self.view.addSubview(collectionView)
        print(self.view.frame)
        collectionView.frame = self.view.frame
        collectionView.keyboardDelegate = self
    }

    func layout(){
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}

extension KeyboardViewController: PokemonKeyboardDelegate{
    func nextKeyboardButtonTapped(){
        advanceToNextInputMode()
//        handleInputModeList(from: <#T##UIView#>, with: <#T##UIEvent#>)
    }

    func sendPokemonWithId(id: Int) {
        while (self.textDocumentProxy.hasText == true)
        {
            self.textDocumentProxy.deleteBackward()
        }
        self.textDocumentProxy.insertText("pok://?id=" + String(id))
    }
}
