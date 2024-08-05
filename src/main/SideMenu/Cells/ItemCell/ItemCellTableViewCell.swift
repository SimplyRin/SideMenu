//
//  ItemCellTableViewCell.swift
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

import UIKit

class ItemCellTableViewCell: UISideMenuTableViewCell {
    
    public static func getIdentifier() -> String {
        return "ItemCellTableViewCell"
    }
        
    public static func getUINib() -> UINib {
        return UINib(nibName: "ItemCell", bundle: nil)
    }
    
    public static func getCellInfo() -> CellInfo {
        return CellInfo()
                .setIdentifier(self.getIdentifier())
                .setUINib(self.getUINib())
    }
    
    public static func getReusableCell(_ tableView: UITableView) -> ItemCellTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.getIdentifier()) as! ItemCellTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    @IBOutlet weak var uiIcon: UIImageView!
    @IBOutlet weak var uiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

