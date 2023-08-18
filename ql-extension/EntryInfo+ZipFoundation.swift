//
//  EntryInfo+ZipFoundation.swift - ZipFoundation用のEntryInfoの拡張
//  ql-extension
//
//  Created by EnchantCode on 2023/08/18.
//

import ZIPFoundation
import Foundation

extension EntryInfo {
    
    /// Zipエントリの情報をもとに初期化
    /// - Parameter entry: エントリ
    init?(_ entry: Entry){
        guard entry.type == .file else {return nil}
        
        // 作成日と更新日どっちかはあるはず
        let createdAt = entry.fileAttributes[.creationDate] as? Date
        let modifiedAt = entry.fileAttributes[.modificationDate] as? Date
        guard createdAt != nil || modifiedAt != nil else {return nil}
        let lastModifiedAt: Date = (createdAt != nil) ? createdAt! : modifiedAt!
        
        self.init(lastModifiedAt: lastModifiedAt, compressedSize: entry.compressedSize, uncompressedSize: entry.uncompressedSize)
    }
}
