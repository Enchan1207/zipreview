//
//  EntryInfo.swift
//  ql-extension
//
//  Created by EnchantCode on 2023/08/18.
//

import Foundation

/// エントリの情報
struct EntryInfo {
    /// 最終変更日時
    let lastModifiedAt: Date
    
    /// 圧縮後のファイルサイズ
    let compressedSize: UInt64
    
    /// 圧縮前のファイルサイズ
    let uncompressedSize: UInt64
}
