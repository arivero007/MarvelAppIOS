//
//  CharactersTableViewController.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import UIKit
import RxSwift

final class CharactersTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
        
    lazy private var charactersVM: CharactersViewModel = {
        return CharactersViewModel()
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        setBindings()
        setLiterals()
        registerCell()
        getCharactersData()
    }
        
    @IBAction func refreshCharacters(_ sender: UIRefreshControl) {
        getCharactersData()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? CharacterViewController, let id = sender as? Int64 else{
            return
        }
        vc.characterId = id
        
    }
}

//MARK: - Class functions

extension CharactersTableViewController{
    
    private func setBindings(){
        charactersVM.bindCharactersViewModelToController = {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "CharacterTableViewCell",
                         bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "menuCell")
    }
    
    private func getCharactersData(){
        if(NetworkConnection.isConnected()){
            charactersVM.getCharacters(view: self)
        }else{
            showAlert(title: "GEN_ADVISE".localized(), message: "NO_INTERNET".localized())
        }
    }
    
    //MARK: - Literals
    
    private func setLiterals(){
        self.navigationItem.title = "character-list-title".localized()
        searchBar.placeholder = "search-bar-text".localized()
    }
}

// MARK: - Table view data source

extension CharactersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersVM.filteredCharacters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = charactersVM.filteredCharacters[indexPath.item].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let characterId = charactersVM.filteredCharacters[indexPath.item].id
        
        performSegue(withIdentifier: "segueCharacter", sender: characterId)
    }
}

// MARK: - Search bar delegate

extension CharactersTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        charactersVM.applyTextFilter(text: searchText)
    }
}
