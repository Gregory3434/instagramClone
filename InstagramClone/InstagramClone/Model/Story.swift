//
//  Story.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import Foundation

struct Story {
    var id = UUID()
    let imageName: String

    static var stories = [Story(imageName: "thailand"),
                          Story(imageName: "cambodge"),
                          Story(imageName: "cambodge2"),
                          Story(imageName: "vietnam"),
                          Story(imageName: "bali"),
                          Story(imageName: "bali2"),
                          Story(imageName: "laos")]
}

extension Story : Hashable { }
