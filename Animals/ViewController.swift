//
//  ViewController.swift
//  Animals
//
//  Created by 前田庸 on 2017/09/09.
//  Copyright © 2017年 Yo Maeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items:[[String]]=[]
    var searchResult:[[String]]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //csvファイル"AnimalInfo.csv"から動物のデータを2次元配列に読み込む
        if let csvPath=Bundle.main.path(forResource:"AnimalInfo",ofType:"csv"){
            do{
                let csvStr=try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)
                let csvArr=csvStr.characters.split(separator:"\n").map(String.init)
                for csvFile in csvArr {
                    let csvSpl=csvFile.components(separatedBy:",")
                    items.append(csvSpl)
                }
            }
            catch{
            }
        }
        
        //items.sort(by:{$0[0]<$1[0]}) //csvファイルから読み込んだ動物のデータを名前の五十音順に並べ替える
        items.reverse()
        
        tableView.dataSource=self
        
        searchBar.delegate=self
        //searchBar.showsCancelButton=true
        searchBar.enablesReturnKeyAutomatically=false
        searchResult=items
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //データの個数を返す
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
        return searchResult.count
    }
    
    //データを返す
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath)->UITableViewCell{
        let cell:UITableViewCell!=tableView.dequeueReusableCell(withIdentifier:"NameCell")
        cell.textLabel?.text=searchResult[indexPath.row][0]
        return cell
    }
    
    //値の受け渡しを行う
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if let selectedRow=tableView.indexPathForSelectedRow{
            let controller=segue.destination as! DetailViewController
            controller.info=searchResult[selectedRow.row]
        }
    }
    
    
    //検索ボタンを押した時の挙動
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true) //キーボードを閉じる
    }
    
    //キャンセルボタンが押された時の挙動
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
        searchBar.resignFirstResponder()
        searchBar.text=""
        searchResult=items
        tableView.reloadData()
    }
    
    //テキストを変更した時の挙動
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult.removeAll()
        
        if searchBar.text==""{
            searchResult=items //検索文字が未入力の時はすべてを表示
        }
        else{
            for data in items{
                if data[0].contains(searchBar.text!){
                 searchResult.append(data)
                }
            }
        }
        
        tableView.reloadData() //表示データを再度読み込む
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton=true
        return true
    }
}

