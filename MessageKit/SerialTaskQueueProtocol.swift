//
//  SerialTaskQueueProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

typealias TaskClosure = (completion: () -> Void) -> Void

protocol SerialTaskQueueProtocol {
    func addTask(task: TaskClosure)
    func start()
    func stop()
    var isEmpty: Bool { get }
}

final class SerialTaskQueue: SerialTaskQueueProtocol {
    private var isBusy = false
    private var isStopped = true
    private var tasksQueue = [TaskClosure]()
    
    func addTask(task: TaskClosure) {
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
    
    private func maybeExecuteNextTask() {
        if !self.isStopped && !self.isBusy {
            if !self.isEmpty {
                let firstTask = self.tasksQueue.removeFirst()
                self.isBusy = true
                firstTask(completion: { [weak self] () -> Void in
                    self?.isBusy = false
                    self?.maybeExecuteNextTask()
                    })
            }
        }
    }
}