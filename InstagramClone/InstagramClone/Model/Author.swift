//
//  Author.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import Foundation

struct Author {
    var id = UUID()
    let name: String
    let photoName: String
    var isSeen: Bool
    var stories: [Story]

    static var authors = [Author(name: "Pierre",
                                 photoName: "pierre",
                                 isSeen: false,
                                 stories: [Story.stories[0]]),
                          Author(name: "Paul",
                                 photoName: "paul",
                                 isSeen: false,
                                 stories: [Story.stories[1]]),
                          Author(name: "Clara",
                                 photoName: "clara",
                                 isSeen: false,
                                 stories: [Story.stories[2],
                                           Story.stories[3]]),
                          Author(name: "Rebecca",
                                 photoName: "rebecca",
                                 isSeen: false,
                                 stories: [Story.stories[4],
                                           Story.stories[5],
                                           Story.stories[6]])]
}

extension Author: Hashable { }
