//
//  SideMenuViewController.swift
//  SideMenu
//
//  Created by Sasai Hiroki on 2024/07/29
//
// Copyright (c) 2024 Sasai Hiroki
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private static var instances: [UIViewController : SideMenuViewController] = [:]
    
    public static func getInstance(_ controller: UIViewController) -> SideMenuViewController {
        if (self.instances[controller] == nil) {
            let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
            let sideMenu = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            _ = sideMenu.setBaseViewController(controller)
            
            self.instances[controller] = sideMenu
        }
        
        return self.instances[controller]!
    }
    
    private var baseViewController: UIViewController!
    // タブバーがある場合設定する
    private var baseTabBarController: UITabBarController?
    
    private var isSideMenuVisible = false
    
    // バックグラウンドビューの暗さ (最大1.0、1.0で真っ黒)
    private var backgroundBrightness: CGFloat = 0.25
    
    public func setBackgroundBrightness(_ alpha: CGFloat) -> SideMenuViewController {
        self.backgroundBrightness = alpha >= 1.0 ? 1.0 : alpha
        return self
    }
    
    // サイドメニュー幅
    private var sideMenuWidth = 300
    
    public func setSideMenuWidth(_ width: Int) -> SideMenuViewController {
        self.sideMenuWidth = width
        return self
    }
    
    // タイトル
    private var navigationTitle: String?
    
    public func setNavigationTitle(_ title: String) -> SideMenuViewController {
        self.navigationTitle = title
        return self
    }
    
    // テーブルに表示するアイテム
    private var cells: [UITableViewCell] = []
    
    public func setCells(_ cells: [UITableViewCell]) -> SideMenuViewController {
        self.cells = cells
        
        return self.reloadData()
    }
    
    // CellInfo
    private var cellInfos: [CellInfo] = []
    
    public func setCellInfo(_ cellInfos: [CellInfo]) -> SideMenuViewController {
        self.cellInfos = cellInfos
        return self
    }
    
    public func setBaseViewController(_ baseViewController: UIViewController!) -> SideMenuViewController {
        self.baseViewController = baseViewController
        return self
    }
    
    public func setBaseTabBarController(_ baseTabBarController: UITabBarController?) -> SideMenuViewController {
        self.baseTabBarController = baseTabBarController
        return self
    }
    
    // サイドメニュー切り替えイベント
    private var toggleSideMenuEvent: (Bool) -> Void = { _ in }
    
    public func setToggleSideMenuEvent(_ event: @escaping (Bool) -> Void) -> SideMenuViewController {
        self.toggleSideMenuEvent = event;
        return self
    }
    
    private var alreadyInit = false;

    public func setupSideMenu() -> SideMenuViewController {
        if (self.alreadyInit) {
            return self;
        }
        
        self.alreadyInit = true;
        
        self.loadView()
        self.viewDidLoad()

        self.viewTop.frame = CGRect(x: -self.viewTop.frame.width, y: self.viewTop.frame.origin.y, width: self.viewTop.frame.width, height: self.viewTop.frame.height)
        self.viewMain.frame = CGRect(x: -self.viewMain.frame.width, y: self.viewMain.frame.origin.y, width: self.viewMain.frame.width, height: self.viewMain.frame.height)

        // TabBarController 使用状態で RootViewController に表示しようとすると TabBar ボタンの位置がずれるのでしない
        self.baseViewController.view.addSubview(self.view)

        self.didMove(toParent: self.baseViewController)
        
        return self
    }
    
    public func toggleSideMenu() -> SideMenuViewController {
        if (self.isSideMenuVisible) {
            self.hideSideMenu()
        } else {
            self.showSideMenu()
        }
    }
    
    public func showSideMenu() -> SideMenuViewController {
        self.view.isHidden = false;
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.viewBackground.alpha = self.backgroundBrightness
            
                self.viewTop.frame = CGRect(x: 0, y: self.viewTop.frame.origin.y, width: self.viewTop.frame.width, height: self.viewTop.frame.height)
                self.viewMain.frame = CGRect(x: 0, y: self.viewMain.frame.origin.y, width: self.viewMain.frame.width, height: self.viewMain.frame.height)
            },
            completion: { _ in
                self.isSideMenuVisible = true
                self.toggleSideMenuEvent(self.isSideMenuVisible)
            }
        )
        
        return self
    }
    
    public func hideSideMenu() -> SideMenuViewController {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.viewBackground.alpha = 0

                self.viewTop.frame = CGRect(x: -self.viewTop.frame.width, y: self.viewTop.frame.origin.y, width: self.viewTop.frame.width, height: self.viewTop.frame.height)
                self.viewMain.frame = CGRect(x: -self.viewMain.frame.width, y: self.viewMain.frame.origin.y, width: self.viewMain.frame.width, height: self.viewMain.frame.height)
            },
            completion: { _ in
                self.view.isHidden = true;

                self.isSideMenuVisible = false
                self.toggleSideMenuEvent(self.isSideMenuVisible)
            }
        )
        
        return self
    }
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // サイドメニュー幅
    @IBOutlet weak var constraintsViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintsViewMain: NSLayoutConstraint!
    
    public func getTableView() -> UITableView {
        return self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // サイドメニュー設定
        self.constraintsViewTop.constant = CGFloat(self.sideMenuWidth)
        self.constraintsViewMain.constant = CGFloat(self.sideMenuWidth)
        
        // ナビゲーションバータイトル設定
        if (self.navigationTitle != nil) {
            self.navigationBarItem.title = self.navigationTitle
        }
        
        // カスタムセルの登録
        for cellInfo in self.cellInfos {
            self.tableView.register(cellInfo.getUINib(), forCellReuseIdentifier: cellInfo.getIdentifier())
        }
        
        // テーブルビュー設定
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // バックグラウンドビュータップイベント
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTappedBackgroundView))
        self.viewBackground.addGestureRecognizer(tapGesture)
    }
    
    public func reloadData() -> SideMenuViewController {
        self.tableView.reloadData()
        return self
    }
    
    // バックグラウンドビュータップ
    @objc func onTappedBackgroundView() {
        _ = self.hideSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.cells[indexPath.row]

        if let table = cell as? UISideMenuTableViewCell {
            if let task = table.getTappedTask() {
                DispatchQueue.main.async(execute: task)
            }
        }
    }
    
}
