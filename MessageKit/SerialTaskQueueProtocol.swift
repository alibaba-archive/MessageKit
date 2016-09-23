//
//  SerialTaskQueueProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

typealias TaskClosure = (_ completion: @escaping () -> Void) -> Void

protocol SerialTaskQueueProtocol {
    func addTask(_ task: @escaping TaskClosure)
    func start()
    func stop()
    var isEmpty: Bool { get }
}

final class SerialTaskQueue: SerialTaskQueueProtocol {

    fileprivate var isBusy = false
    fileprivate var isStopped = true
    fileprivate var tasksQueue = [TaskClosure]()

    func addTask(_ task: @escaping TaskClosure) {
        self.tasksQueue.append(task)
        self.maybeExecuteNextTask()
    }

    func start() {
        self.isStopped = false
        self.maybeExecuteNextTask()
    }

    func stop() {
        self.isStopped = true
    }

    var isEmpty: Bool {
        return self.tasksQueue.isEmpty
    }

    fileprivate func maybeExecuteNextTask() {
        if !self.isStopped && !self.isBusy {
            if !self.isEmpty {
                let firstTask = self.tasksQueue.removeFirst()
                self.isBusy = true

                firstTask({ [weak self] () -> Void in
                    self?.isBusy = false
                    self?.maybeExecuteNextTask()
                })
            }
        }
    }
}
