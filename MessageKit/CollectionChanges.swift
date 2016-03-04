//
//  CollectionChanges.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

struct CollectionChangeMove: Equatable, Hashable {
    let indexPathOld: NSIndexPath
    let indexPathNew: NSIndexPath
    init(indexPathOld: NSIndexPath, indexPathNew: NSIndexPath) {
        self.indexPathOld = indexPathOld
        self.indexPathNew = indexPathNew
    }
    
    var hashValue: Int { return indexPathOld.hash ^ indexPathNew.hash }
}

func == (lhs: CollectionChangeMove, rhs: CollectionChangeMove) -> Bool {
    return lhs.indexPathOld == rhs.indexPathOld && lhs.indexPathNew == rhs.indexPathNew
}

struct CollectionChanges {
    let insertedIndexPaths: Set<NSIndexPath>
    let deletedIndexPaths: Set<NSIndexPath>
    let movedIndexPaths: [CollectionChangeMove]
    
    init(insertedIndexPaths: Set<NSIndexPath>, deletedIndexPaths: Set<NSIndexPath>, movedIndexPaths: [CollectionChangeMove]) {
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
        self.movedIndexPaths = movedIndexPaths
    }
}

func generateChanges(oldCollection oldCollection: [UniqueIdentificable], newCollection: [UniqueIdentificable]) -> CollectionChanges {
    func generateIndexesById(uids: [String]) -> [String: Int] {
        var map = [String: Int](minimumCapacity: uids.count)
        for (index, uid) in uids.enumerate() {
            map[uid] = index
        }
        return map
    }
    
    let oldIds = oldCollection.map { $0.uid }
    let newIds = newCollection.map { $0.uid }
    let oldIndexsById = generateIndexesById(oldIds)
    let newIndexsById = generateIndexesById(newIds)
    var deletedIndexPaths = Set<NSIndexPath>()
    var insertedIndexPaths = Set<NSIndexPath>()
    var movedIndexPaths = [CollectionChangeMove]()
    
    // Deletetions
    for oldId in oldIds {
        let isDeleted = newIndexsById[oldId] == nil
        if isDeleted {
            deletedIndexPaths.insert(NSIndexPath(forItem: oldIndexsById[oldId]!, inSection: 0))
        }
    }
    
    // Insertions and movements
    for newId in newIds {
        let newIndex = newIndexsById[newId]!
        let newIndexPath = NSIndexPath(forItem: newIndex, inSection: 0)
        if let oldIndex = oldIndexsById[newId] {
            if oldIndex != newIndex {
                movedIndexPaths.append(CollectionChangeMove(indexPathOld: NSIndexPath(forItem: oldIndex, inSection: 0), indexPathNew: newIndexPath))
            }
        } else {
            insertedIndexPaths.insert(newIndexPath)
        }
    }
    
    return CollectionChanges(insertedIndexPaths: insertedIndexPaths, deletedIndexPaths: deletedIndexPaths, movedIndexPaths: movedIndexPaths)
}
