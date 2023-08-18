//
//  Node+ZipFoundation.swift - ZipFoundation用のNodeの拡張
//  ql-extension
//
//  Created by EnchantCode on 2023/08/18.
//

import ZIPFoundation
import Foundation

extension Node.Kind {
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

extension Node {
    
    /// ツリーノードにエントリを追加する
    /// - Parameters:
    ///   - entry: 追加するエントリ
    ///   - destination: 配置先を表すURL
    /// - Note: `destination` はエントリのルートからの相対URLである必要があります。
    func addEntry(entry: Entry, destination: URL){
        let pathComponents = Array(destination.pathComponents[1...])
        appendChild(pathcomponents: pathComponents, kind: .init(entrytype: entry.type), entryInfo: .init(entry))
    }
}

