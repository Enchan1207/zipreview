//
//  Node.swift
//  zipreview-ql
//
//  Created by EnchantCode on 2023/08/15.
//

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
    }
    
    /// ノードの種類
    let kind: Kind
    
    /// ノード名
    let name: String
    
    /// ノードが持つエントリの付加情報
    let entryInfo: EntryInfo?
    
    /// 親ノード
    private (set) public var parent: Node?
    
    /// 子ノードの配列
    private (set) public var children: [Node]
    
    init(kind: Kind, name: String, entryInfo: EntryInfo?, parent: Node? = nil, children: [Node] = []){
        self.kind = kind
        self.name = name
        self.entryInfo = entryInfo
        self.parent = parent
        self.children = children
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name && lhs.kind == rhs.kind
    }
    
    /// 子ノードを追加する
    /// - Parameter node: 追加するノード
    /// - Note: このインスタンスの`kind`が `.directory` であり、同名同種の子ノードがない場合のみ追加されます。
    private func appendChild(_ node: Node){
        guard self.kind == .directory, !self.children.contains(where: {$0 == node}) else {return}
        
        // 親として登録し、子に追加
        node.parent = self
        self.children.append(node)
    }
    
    /// pathコンポーネントの配列に従い、子ノードを追加する
    /// - Parameters:
    ///   - pathcomponents: pathコンポーネントの配列
    ///   - kind: エントリの種類
    ///   - entryInfo: エントリが持つ情報
    func appendChild(pathcomponents: [String], kind: Kind, entryInfo: EntryInfo?){
        guard let firstComponent = pathcomponents.first else {return}
        
        // このコンポーネントが最後なら、子ノードに追加して終わり
        if pathcomponents.count == 1 {
            self.appendChild(.init(kind: kind, name: firstComponent, entryInfo: entryInfo, parent: self))
            return
        }
        
        // このコンポーネントと同名のディレクトリノードを探す
        if !self.children.contains(where: {$0.name == firstComponent && $0.kind == .directory}){
            // なければ作る この際、エントリ情報は伝播させない
            self.appendChild(.init(kind: .directory, name: firstComponent, entryInfo: nil, parent: self))
        }
        
        // 対象のノードを取得し、appendChildを呼び出す
        let targetNode: Node = self.children.first(where: {$0.name == firstComponent && $0.kind == .directory})!
        targetNode.appendChild(pathcomponents: Array(pathcomponents[1...]), kind: kind, entryInfo: entryInfo)
    }
    
}
