//
//  CharactersTableViewController.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import UIKit
import RxSwift

class CharactersTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var characters = [Character]()
    private var filteredCharacters = [Character]()
    private var characterId: Int64?
    
    private let disposeBag = DisposeBag()
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        registerCell()
        getCharactersData()
    }
    
    //MARK: Class functions
    
    private func registerCell() {
        let cell = UINib(nibName: "CharacterTableViewCell",
                         bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "menuCell")
    }
    
    private func getCharactersData(){
        if(NetworkConnection.isConnected()){
            getCharactersWS()
            //oldGetCharacters()
        }else{
            //Utils.showAlert(title: Utils.translateText(text: "GEN_ADVISE"), text: Utils.translateText(text: "NO_INTERNET"), view: self)
        }
    }
    
    // MARK: Refresh Control
    
    @IBAction func refreshCharacters(_ sender: UIRefreshControl) {
        getCharactersData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredCharacters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = filteredCharacters[indexPath.item].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        characterId = filteredCharacters[indexPath.item].id
        
        performSegue(withIdentifier: "segueCharacter", sender: nil)
    }
    
    //MARK: WS
    
    private func getCharactersWS(){
        
        let characters: Observable<MarvelData> = RXWrapper.shared.request(apiRequest: CharactersRequest())
        
        characters
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { marvelData in
                self.characters = marvelData.data.results
                self.filteredCharacters = marvelData.data.results
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } onError: { error in
                //Utils.showAlert(title: Utils.translateText(text: "WS_ERROR"), text: nil, view: self)
                self.refreshControl?.endRefreshing()
            } onCompleted: {
                self.refreshControl?.endRefreshing()
            }.disposed(by: disposeBag)
        
    }
    
    private func oldGetCharacters(){
        
        WebServices.getAllCharacters()
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { marvelData in
                self.characters = marvelData.data.results
                self.filteredCharacters = marvelData.data.results
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } onError: { error in
                //Utils.showAlert(title: Utils.translateText(text: "WS_ERROR"), text: nil, view: self)
                self.refreshControl?.endRefreshing()
            } onCompleted: {
                self.refreshControl?.endRefreshing()
            }.disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCharacter"){
            let cp = segue.destination as! CharacterViewController
            cp.characterId = self.characterId
        }
    }
    
}

//MARK: Class Extensions

extension CharactersTableViewController: UISearchBarDelegate{
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCharacters = []
        
        if searchText == ""{
            filteredCharacters = characters
        }else{
            for item in characters{
                
                if item.name.contains(searchText){
                    filteredCharacters.append(item)
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
