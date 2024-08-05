//
//  ViewController.swift
//  SideMenu
//
//  Created by Sasai Hiroki on 2024/08/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onMenuButtonTapped(_ sender: Any) {
        let sideMenu = SideMenuViewController.getInstance(self)

        // サイドメニューのテーブル内に表示するカスタムセルの登録
        var cellInfos: [CellInfo] = []
        cellInfos.append(SectionCellTableViewCell.getCellInfo())
        cellInfos.append(ItemCellTableViewCell.getCellInfo())
        
        // setCells()、toggleSideMenu() 前にかならず一度 setupSideMenu() が必要
        _ = sideMenu
        
                // サイドメニューの幅を指定
                // デフォルト: 300
                .setSideMenuWidth(300)
        
                // カスタムセル登録のため
                .setCellInfo(cellInfos)
        
                // サイドメニュータイトル
                .setNavigationTitle("サイドメニュー")
        
                // サイドメニューが開いている時それ以外の場所の暗さを指定最大 1.0 (真っ黒)、最小 0 (透明)
                // デフォルト: 0.25
                .setBackgroundBrightness(0.25)
        
                // 表示するための設定
                .setupSideMenu()
        
        // サイドメニュー内容
        var cells: [UITableViewCell] = []
        
        let sectionCell = SectionCellTableViewCell.getReusableCell(sideMenu.getTableView())
        sectionCell.uiLabel.text = "基本設定"
        cells.append(sectionCell)
        
        let itemCell = ItemCellTableViewCell.getReusableCell(sideMenu.getTableView())
        itemCell.uiIcon.image = UIImage(systemName: "info.circle")
        itemCell.uiLabel.text = "アラート表示"
        itemCell.setTappedTask(DispatchWorkItem {
            // アラートコントローラを作成
            let alert = UIAlertController(title: "アラートテスト", message: "テストアラートです", preferredStyle: .alert)
            
            // OKアクションを作成
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OKボタンが押されました")
            }

            // アクションをアラートコントローラに追加
            alert.addAction(action)

            // アラートを表示
            self.present(alert, animated: true, completion: nil)
        })
        cells.append(itemCell)
        
        _ = sideMenu
        
                // サイドメニューに表示するセル一覧
                .setCells(cells)
                
                // サイドメニュー表示
                .toggleSideMenu()
    }
    
}

