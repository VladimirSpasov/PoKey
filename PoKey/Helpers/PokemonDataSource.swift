//
//  PokemonDataSource.swift
//  PoKey
//
//  Created by Vladimir Spasov on 6/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import Foundation
import PokemonKit
import Alamofire

protocol PokemonDataDelegate: class{
    func finishedLoading()

    func newPokemon(index: Int)
}

class PokemonDataSource{

    static let sharedInstance = PokemonDataSource()

    var ids = [Int]()

    var pokemons = [PKMPokemon]()
    var species = [PKMPokemonSpecies]()

    var newPokemonId = 0


    weak var delegate: PokemonDataDelegate?


    private init() {
        setup()
    }

    func setup(){
        let sharedCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 4 * 1024 * 1024, diskPath: "pokemonCache")

        URLCache.shared = sharedCache

        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .returnCacheDataElseLoad
        Alamofire.SessionManager.default.session.configuration.urlCache = sharedCache

        UserDefaults(suiteName: "group.PoKey")!.register(defaults: [
            "pokemonIds" : [],
            "SkipTutorial" : false,
            ])
        UserDefaults(suiteName: "group.PoKey")!.synchronize()

        let defaults = UserDefaults(suiteName: "group.PoKey")

        ids = defaults?.array(forKey: "pokemonIds") as! [Int]
        if (ids.isEmpty){
            generateIds()
        }
        if pokemons.isEmpty{
            fetchPokemons()
        }
        if species.isEmpty{
            fetchSpecies()
        }
    }

    func addPokemonWith(id: Int){
        if (!ids.contains(id)){
            ids.append(id)
            newPokemonId = id
            fetchPokemon(id: id)
            fetchSpecie(id: id)
        }
    }

    func checkFinished(){
        if (self.pokemons.count == self.ids.count && (self.species.count == self.ids.count)){
            self.ids = self.ids.sorted(by: {$0 < $1})
            self.pokemons = self.pokemons.sorted(by: {$0.id! < $1.id!})
            self.species = self.species.sorted(by: {$0.id! < $1.id!})

            let defaults = UserDefaults(suiteName: "group.PoKey")
            defaults?.set(ids, forKey: "pokemonIds")
            UserDefaults(suiteName: "group.PoKey")!.synchronize()

            self.delegate?.finishedLoading()
            if(newPokemonId != 0){
                self.delegate?.newPokemon(index: ids.index(of: newPokemonId)!)
                newPokemonId = 0
            }

        }
    }

    func generateIds(){
        for _ in 1...10{
            ids.append(Int(arc4random_uniform(720) + 1))
        }

        let defaults = UserDefaults(suiteName: "group.PoKey")
        defaults?.set(ids, forKey: "pokemonIds")
        UserDefaults(suiteName: "group.PoKey")!.synchronize()
    }

    func fetchPokemons(){
        for id in ids{
            fetchPokemon(id: id)
        }
    }

    func fetchPokemon(id: Int){
        PokemonKit.fetchPokemon(String(id))
            .then { pokemonInfo -> Void in
                self.pokemons.append(pokemonInfo)
                self.checkFinished()
            }.catch {error in
                print(error)
        }
    }

    func fetchSpecie(id: Int){
        PokemonKit.fetchPokemonSpecies(String(id))
            .then { pokemonInfo -> Void in
                self.species.append(pokemonInfo)
                self.checkFinished()
            }.catch {error in
                print(error)
        }
    }

    func fetchSpecies(){
        for id in ids{
            fetchSpecie(id: id)
        }
    }
}
