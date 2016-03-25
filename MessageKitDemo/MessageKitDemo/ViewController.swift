//
//  ViewController.swift
//  MessageKitDemo
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit
import MessageKit
//import Kingfisher

class TextMessageTestHandler: BaseMessageInteractionHandlerProtocol {
    typealias ViewModelT = TextMessageViewModel
    
    func userDidTapOnFailIcon(viewModel viewModel: ViewModelT) {
        print("点击失败按钮")
    }
    
    func userDidTapOnBubble(viewModel viewModel: ViewModelT) {
        print("点击bubble")
    }
    
    func userDidLongPressOnBubble(viewModel viewModel: ViewModelT) {
        print("长按bubble")
    }
    
    func userDidTapOnAvatar(viewModel viewModel: ViewModelT) {
        print("点击头像")
    }
}

class PhotoMessageTestHandler: BaseMessageInteractionHandlerProtocol {
    typealias ViewModelT = PhotoMessageViewModel
    
    func userDidTapOnFailIcon(viewModel viewModel: ViewModelT) {
        print("点击图片失败")
    }
    
    func userDidTapOnBubble(viewModel viewModel: ViewModelT) {
        print("点击图片")
    }
    
    func userDidLongPressOnBubble(viewModel viewModel: ViewModelT) {
        print("长按图片")
    }
    func userDidTapOnAvatar(viewModel viewModel: ViewModelT) {
        print("点击头像")
    }
}

class FileMessageTestHandler: BaseMessageInteractionHandlerProtocol {
    typealias ViewModelT = FileMessageViewModel
    
    func userDidTapOnFailIcon(viewModel viewModel: ViewModelT) {
        
    }
    
    func userDidTapOnBubble(viewModel viewModel: ViewModelT) {
        print("点击文件")
    }
    
    func userDidLongPressOnBubble(viewModel viewModel: ViewModelT) {
        
    }
    func userDidTapOnAvatar(viewModel viewModel: ViewModelT) {
        print("点击头像")
    }
}

class CustomMessageTestHandler: BaseMessageInteractionHandlerProtocol {
    typealias ViewModelT = CustomMessageViewModel
    
    func userDidTapOnFailIcon(viewModel viewModel: ViewModelT) {
        
    }
    
    func userDidTapOnBubble(viewModel viewModel: ViewModelT) {
        print("点击自定义")
    }
    
    func userDidLongPressOnBubble(viewModel viewModel: ViewModelT) {
        
    }
    func userDidTapOnAvatar(viewModel viewModel: ViewModelT) {
        print("点击头像")
    }
}

class FakeDataSource: MessageDataSourceProtocol {
    var hasMoreNext = true
    var hasMorePrevious = true
    var wasRequestedForPrevious = false
    var wasRequestedForMessageCountContention = false
    var chatItemsForLoadNext: [MessageItemProtocol]?
    var messageItems = [MessageItemProtocol]()
    weak var delegate: MessageDataSourceDelegateProtocol?
    
    func loadNext(completion: () -> Void) {
        if let chatItemsForLoadNext = self.chatItemsForLoadNext {
            self.messageItems = chatItemsForLoadNext
        }
        completion()
    }
    
    func loadPrevious(completion: () -> Void) {
        self.wasRequestedForPrevious = true
        completion()
    }
    
    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion:(didAdjust: Bool) -> Void) {
        self.wasRequestedForMessageCountContention = true
        completion(didAdjust: false)
    }
}

class ddd: MessageItemsDecoratorProtocol {
    func decorateItems(chatItems: [MessageItemProtocol]) -> [DecoratedMessageItem] {
        
        var arr = [DecoratedMessageItem]()
        for c in chatItems {
            let d = DecoratedMessageItem(messageItem: c, decorationAttributes: ItemDecorationAttributes(bottomMargin: 30, showsTail: false))
            arr.append(d)
        }
        return arr
    }
}

struct testModel {
    enum senderType: String {
        case Text = "text-message"
        case Photo = "photo-message"
        case File = "file-message"
        case Custom = "custom-message"
    }
    
    var uid: String
    var senderId: String
    var type: senderType
    var isIncoming: Bool
    var text: String
    var isSuccess: Bool
    
    init(uid: String, sid: String, type: senderType, coming: Bool, text: String, isSuccess: Bool = true) {
        self.uid = uid
        self.senderId = sid
        self.type = type
        self.isIncoming = coming
        self.text = text
        self.isSuccess = isSuccess
    }
    
}

class ViewController: MessageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = FPSLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 64))
        self.navigationController?.view.addSubview(label)
        self.title = "聊天测试"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "一组", style: .Done, target: self, action: #selector(addNewMessages)),
            UIBarButtonItem(title: "一个", style: .Done, target: self, action: #selector(addNewMessage))
        ]
        
        let fake = FakeDataSource()
        let modelData = [
            testModel(uid:"1", sid: "dd", type: .Text, coming: true, text: "你好呀!"),
            testModel(uid:"2", sid: "dd", type: .Text, coming: false, text: "您好"),
            testModel(uid:"3", sid: "dd", type: .Text, coming: true, text: "中巴经济走廊，以通过互联互通更好地发掘贸易和投资机遇为目标，预计将为巴基斯坦的能源、交通和基础设施的发展做出显著贡献。巴基斯坦原先缓慢发展的经济通过转型将为普通民众带来长期繁荣。即便中巴经济走廊遇到挑战，两国已庄严承诺，将坚定面对挑战，把夙愿变成现实。", isSuccess: true),
            testModel(uid:"4", sid: "dd", type: .Text, coming: false, text: "饰，那么该子类的方法会把原来继承过来的父类的方法隐藏，而不是重写。通俗的讲就是父类的方法和子类的方法是两个没有关系的方法，具体调用哪一个方法是看是哪个对象的引用；这种父子类方法也不在存在多态的性质。《Java编程思想》中这样提到“只有普通的方法调用可以是多态的”。下面代码为例"),
            testModel(uid:"5", sid: "dd", type: .Photo, coming: true, text: "dsfsd"),
            testModel(uid:"6", sid: "dd", type: .Text, coming: false, text: "静态的方法不能覆写，也不能被重写。总之，静态的没有重写"),
            testModel(uid:"7", sid: "dd", type: .Text, coming: true, text: "JtextPanel在JDK1.6下默认是可以实现中英文自动换行的，但是在高版本中却无法实现自动换行"),
            testModel(uid:"8", sid: "dd", type: .Text, coming: false, text: "实现类似qq的屏幕边缘隐藏效果。 使用方法：new WindowAutoHide(window"),
            testModel(uid:"9", sid: "dd", type: .Text, coming: true, text: "以前在网上瞎转悠的时候就发现很多人为用Java实现QQ登陆后的面板的问题感到十分头疼，最近我因在写模拟QQ的项目，故不可或缺的遇到了这一个问题，在网上我google了，百度了，最终发现的是有很多人被这一问题困扰，却没有解决的方案，估计是那些写出来了的人，没有发布到网上来，如今，经过自己的多方面查找资料，终于把他写出来了，也不枉昨晚熬夜了，呵呵"),
            testModel(uid:"10", sid: "dd", type: .Text, coming: false, text: "dsfsd"),
            testModel(uid:"11", sid: "dd", type: .Photo, coming: true, text: "dsfsd"),
            testModel(uid:"12", sid: "dd", type: .File, coming: false, text: "dsfsd"),
            testModel(uid:"13", sid: "dd", type: .Text, coming: true, text: "18717824984"),
            testModel(uid:"14", sid: "dd", type: .Text, coming: false, text: "dsfsd"),
            testModel(uid:"15", sid: "dd", type: .Text, coming: true, text: "dsfsd"),
            testModel(uid:"16", sid: "dd", type: .Photo, coming: false, text: "dsfsd"),
            testModel(uid:"17", sid: "dd", type: .Text, coming: true, text: "www.baidu.com", isSuccess: true),
            testModel(uid:"19", sid: "dd", type: .File, coming: true, text: "标题位置可以分别设置为上下左右，4个位置", isSuccess: true),
            testModel(uid:"19", sid: "dd", type: .File, coming: true, text: "标题位置可以分别设置为上下左右，4个位置", isSuccess: true),
            testModel(uid:"18", sid: "dd", type: .Text, coming: false, text: "dsfsd", isSuccess: true),
            testModel(uid:"19", sid: "dd", type: .Text, coming: true, text: "标题位置可以分别设置为上下左右，4个位置", isSuccess: true),
            testModel(uid:"18", sid: "dd", type: .Custom, coming: false, text: "dsfsd", isSuccess: true),
            testModel(uid:"19", sid: "dd", type: .Custom, coming: true, text: "标题位置可以分别设置为上下左右，4个位置", isSuccess: true)
        ]
        
        var source = [MessageItemProtocol]()
        
        for m in modelData {
            var status: MessageStatus
            if m.isSuccess {
                status = .Success
            } else {
                status = .Failed
            }
            
            let baseMessageModel = MessageModel(uid: m.uid, senderId: m.senderId, type: m.type.rawValue, isIncoming: m.isIncoming, showsBorder: false, dateLabel: "dsfdsf", status: status, avatarClosure: { imageView in
//                imageView.kf_setImageWithURL(NSURL(string: "https://striker.teambition.net/thumbnail/110771552384086e16cb0e32133ba589cf98/w/200/h/200")!, placeholderImage: nil)
            })
            
            if m.type == .Text {
                let textMessageModel = TextMessageModel(messageModel: baseMessageModel, text: m.text)
                source.append(textMessageModel)
            } else if m.type == .Photo{
//                let photoMessageModelIncoming = PhotoMessageModel(messageModel: baseMessageModel, imageSize: CGSize(width: 300, height: 600), image: UIImage())
                
                let photoMessageModelIncoming = PhotoMessageModel(messageModel: baseMessageModel, imageSize:  CGSize(width: 300, height: 600), imageClosure: { (imageview) -> () in
//                    imageview.kf_setImageWithURL(NSURL(string: "https://striker.teambition.net/thumbnail/110771552384086e16cb0e32133ba589cf981/w/800/h/200")!, placeholderImage: nil)
                })
                
                source.append(photoMessageModelIncoming)
            } else if m.type == .File {
                let fileMessageModel = FileMessageModel(messageModel: baseMessageModel, fileName: "iPad Design.psd", fileSize: "30M", fileFolderColor: UIColor.redColor())
                source.append(fileMessageModel)
            } else {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
                view.backgroundColor = UIColor.redColor()
                let customMessageModel = CustomMessageModel(messageModel: baseMessageModel, customView: view)
                source.append(customMessageModel)
            }
        }
        
        
        fake.messageItems = source
        fake.delegate = self
        self.messageDataSource = fake
        self.messageItemsDecorator = ddd()
        self.inputContainerBottomConstraint.constant = 0
    }
    
    override func createPresenterBuilders() -> [MessageItemType : [ItemPresenterBuilderProtocol]] {
        let builder = TextMessagePresenterBuilder(viewModelBuilder: TextMessageViewModelDefaultBuilder(), interactionHandler: TextMessageTestHandler())
        
        let photobuilder = PhotoMessagePresenterBuilder(viewModelBuilder: PhotoMessageViewModelDefaultBuilder(), interactionHandler: PhotoMessageTestHandler())
        
        let filebuilder = FileMessagePresenterBuilder(viewModelBuilder: FileMessageViewModelDefaultBuilder(), interactionHandler: FileMessageTestHandler())
        
        let custombuilder = CustomMessagePresenterBuilder(viewModelBuilder: CustomMessageViewModelDefaultBuilder(), interactionHandler: CustomMessageTestHandler())
        
        return [
            "text-message" : [
                builder
            ]
            ,
            "photo-message": [
                photobuilder
            ],
            "file-message": [
                filebuilder
            ],
            "custom-message": [
                custombuilder
            ]
        ]
    }
    
    override func createInputView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        view.backgroundColor = UIColor.redColor()
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addNewMessage() {
    
        sendNewMessage(randomModel())
    }
    
    func addNewMessages() {
        
        let array = [randomModel(),randomModel(),randomModel()]
        sendNewMessages(array)
    }
    
    func randomModel() -> MessageItemProtocol {
        let randomNumber: Int = Int(arc4random() % 3)
        let a = [
            "你好呀!",
            "我挺好的",
            "你真的很好嘛?"
        ]
        let messageModel = MessageModel(uid: "dsfsdf\(Int(arc4random() % 300))", senderId: "dsfsdf", type: "text-message", isIncoming: true, showsBorder: false, dateLabel: "", status: .Success, avatarClosure: { imageView in
            
        })
        let textMessageModel = TextMessageModel(messageModel: messageModel, text: "dsfsdfsdfsdfsdf\(a[randomNumber])")
        return textMessageModel
    }
}
