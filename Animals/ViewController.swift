//
//  ViewController.swift
//  Animals
//
//  Created by 前田庸 on 2017/09/09.
//  Copyright © 2017年 Yo Maeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var items:[[String]]=[]
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
        return items.count
    }
    
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath)->UITableViewCell{
        let cell:UITableViewCell!=tableView.dequeueReusableCell(withIdentifier:"NameCell")
        cell.textLabel?.text=items[indexPath.row][0]
        return cell
    }
    
    //値の受け渡しを行う
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if let selectedRow=tableView.indexPathForSelectedRow{
            let controller=segue.destination as! DetailViewController
            controller.info=items[selectedRow.row]
        }
    }
}

