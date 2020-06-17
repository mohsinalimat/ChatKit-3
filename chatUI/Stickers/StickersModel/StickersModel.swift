//
//  StickersModel.swift
//  chatUI
//
//  Created by Faris Albalawi on 6/16/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit

struct stickerPacks {
    var packnames: String?
    var icon: URL?
    var stickers: [stickers]?
    init(){}
}

struct stickers {
    var imageURL: URL?
    var name: String?
}
