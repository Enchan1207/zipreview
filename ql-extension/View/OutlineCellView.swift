//
//  OutlineCellView.swift
//  ql-extension
//
//  Created by EnchantCode on 2023/08/14.
//

import Cocoa
import Instantiate
import InstantiateStandard

class OutlineCellView: NSTableCellView, NibInstantiatable {
    
    /// エントリの種類 (file/directory/symlink) を表すアイコン
    @IBOutlet weak var entryKindIcon: NSImageView!
    
    /// エントリがリンクかどうかを表すインジケータ
    @IBOutlet weak var linkIndicator: NSImageView! {
        didSet {
            linkIndicator.image = .init(systemSymbolName: "arrowshape.turn.up.right.fill", accessibilityDescription: nil)
        }
    }
    
    /// エントリ名
    @IBOutlet weak var entryNameLabel: NSTextField!
    
    func configureCell(_ node: Node){
        setIcon(node.kind)
        entryNameLabel.stringValue = node.name
    }
    
    private func setIcon(_ kind: Node.Kind){
        linkIndicator.isHidden = kind != .symlink
        let imageSymbolName: String = { kind in
            switch kind {
            case .file:
                return "doc"
            case .directory:
                return "folder"
            case .symlink:
                return "folder"
            }
        }(kind)
        entryKindIcon.image = .init(systemSymbolName: imageSymbolName, accessibilityDescription: nil)
    }
    
}
