//
//  CollectionChanges.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

struct CollectionChangeMove: Equatable, Hashable {
    let indexPathOld: IndexPath
    let indexPathNew: IndexPath

    init(indexPathOld: IndexPath, indexPathNew: IndexPath) {
        self.indexPathOld = indexPathOld
        self.indexPathNew = indexPathNew
    }

    var hashValue: Int { return (indexPathOld as NSIndexPath).hash ^ (indexPathNew as NSIndexPath).hash }
}

func == (lhs: CollectionChangeMove, rhs: CollectionChangeMove) -> Bool {
    return lhs.indexPathOld == rhs.indexPathOld && lhs.indexPathNew == rhs.indexPathNew
}

struct CollectionChanges {
    let insertedIndexPaths: Set<IndexPath>
    let deletedIndexPaths: Set<IndexPath>
    let movedIndexPaths: [CollectionChangeMove]

    init(insertedIndexPaths: Set<IndexPath>, deletedIndexPaths: Set<IndexPath>, movedIndexPaths: [CollectionChangeMove]) {
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
        self.movedIndexPaths = movedIndexPaths
    }
}

func generateChanges(oldCollection: [UniqueIdentificable], newCollection: [UniqueIdentificable]) -> CollectionChanges {
    func generateIndexesById(_ uids: [String]) -> [String: Int] {
        var map = [String: Int](minimumCapacity: uids.count)
        for (index, uid) in uids.enumerated() {
            map[uid] = index
        }
        return map
    }

    let oldIds = oldCollection.map { $0.uid }
    let newIds = newCollection.map { $0.uid }
    let oldIndexsById = generateIndexesById(oldIds)
    let newIndexsById = generateIndexesById(newIds)
    var deletedIndexPaths = Set<IndexPath>()
    var insertedIndexPaths = Set<IndexPath>()
    var movedIndexPaths = [CollectionChangeMove]()

    // Deletetions
    for oldId in oldIds {
        let isDeleted = newIndexsById[oldId] == nil
        if isDeleted {
            deletedIndexPaths.insert(IndexPath(item: oldIndexsById[oldId]!, section: 0))
        }
    }

    // Insertions and movements
    for newId in newIds {
        let newIndex = newIndexsById[newId]!
        let newIndexPath = IndexPath(item: newIndex, section: 0)
        if let oldIndex = oldIndexsById[newId] {
            if oldIndex != newIndex {
                movedIndexPaths.append(CollectionChangeMove(indexPathOld: IndexPath(item: oldIndex, section: 0), indexPathNew: newIndexPath))
            }
        } else {
            insertedIndexPaths.insert(newIndexPath)
        }
    }

    return CollectionChanges(insertedIndexPaths: insertedIndexPaths, deletedIndexPaths: deletedIndexPaths, movedIndexPaths: movedIndexPaths)
}
