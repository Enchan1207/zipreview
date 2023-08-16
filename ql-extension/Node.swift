//
//  Node.swift
//  zipreview-ql
//
//  Created by EnchantCode on 2023/08/15.
//

import ZIPFoundation
import Foundation

/// エントリツリーのノード
class Node: Equatable {
    
    /// ノードが表すエントリの種類
    enum Kind {
        /// ディレクトリ
        case directory
        
        /// ファイル
        case file
        
        /// シンボリックリンク
        case symlink
        
        /// ZipFoundationのEntry.EntryType列挙体から初期化
        /// - Parameter entrytype: ファイルエントリのタイプ
        init(entrytype: Entry.EntryType) {
            switch entrytype {
            case .file:
                self = .file
            case .directory:
                self = .directory
            case .symlink:
                self = .symlink
            }
        }
    }
    
    /// ノードの種類
    let kind: Kind
    
    /// ノード名
    let name: String
    
    /// 親ノード
    private (set) public var parent: Node?
    
    /// 子ノードの配列
    private (set) public var children: [Node]
    
    init(kind: Kind, name: String, parent: Node? = nil, children: [Node] = []){
        self.kind = kind
        self.name = name
        self.parent = parent
        self.children = children
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name && lhs.kind == rhs.kind
    }
    
    /// 子ノードを追加する
    /// - Parameter node: 追加するノード
    /// - Note: このインスタンスの`kind`が `.directory` であり、同名同種の子ノードがない場合のみ追加されます。
    func appendChild(_ node: Node){
        guard self.kind == .directory, !self.children.contains(where: {$0 == node}) else {return}
        
        // 親として登録し、子に追加
        node.parent = self
        self.children.append(node)
    }
    
    /// pathコンポーネントの配列に従い、子ノードを追加する
    /// - Parameter pathcomponents: pathコンポーネントの配列
    func appendChild(pathcomponents: [String], kind: Kind){
        guard let firstComponent = pathcomponents.first else {return}
        
        // このコンポーネントが最後なら、子ノードに追加して終わり
        if pathcomponents.count == 1 {
            self.appendChild(.init(kind: kind, name: firstComponent, parent: self))
            return
        }
        
        // このコンポーネントと同名のディレクトリノードを探す なければ作っておく
        if !self.children.contains(where: {$0.name == firstComponent && $0.kind == .directory}){
            self.appendChild(.init(kind: .directory, name: firstComponent, parent: self))
        }
        
        // 対象のノードを取得し、appendChildを呼び出す
        let targetNode: Node = self.children.first(where: {$0.name == firstComponent && $0.kind == .directory})!
        targetNode.appendChild(pathcomponents: Array(pathcomponents[1...]), kind: kind)
    }
    
}
