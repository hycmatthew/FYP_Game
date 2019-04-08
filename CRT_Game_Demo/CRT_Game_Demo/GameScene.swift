//
//  GameScene.swift
//  CRT_Game_Demo
//
//  Created by Matthew Chan on 14/2/2019.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gameDefault = UserDefaults.standard
    var theLang = 0
    var soundOn = true
    var optionOpen = false
    var allowTouch = true
    
    var game_layer = SKSpriteNode()
    var gameLabel = SKLabelNode()
    var startButton = SKLabelNode()
    var modeButton = SKLabelNode()
    var tutorialButton = SKLabelNode()
    var optionButton = SKLabelNode()
    
    var option_layer = SKSpriteNode()
    var optionlayer_soundbtn = SKLabelNode()
    var optionlayer_resetbtn = SKLabelNode()
    var optionlayer_closebtn = SKSpriteNode()
    
    //==================== Sound Action Setting ====================
    let clickSound = SKAction.playSoundFileNamed("sound_click.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.white
        
        self.getDataFunction()
        self.createScene()
        self.scaleTheGameLayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(allowTouch){
            for t in touches {
                let positionInScene = t.location(in: self)
                let positionInOption = t.location(in: option_layer)
                if(optionOpen){
                    if(optionlayer_closebtn.contains(positionInOption)){
                        self.gameSoundFunction(num: 1)
                        self.optionMenuFunction()
                    }
                    
                    if(optionlayer_soundbtn.contains(positionInOption)){
                        self.gameSoundFunction(num: 1)
                        self.updateGameSoundFunction()
                    }
                    
                    if(optionlayer_resetbtn.contains(positionInOption)){
                        self.gameSoundFunction(num: 1)
                        self.resetMapNumberFunction()
                        self.optionMenuFunction()
                    }
                }else{
                    if(startButton.contains(positionInScene)){
                        self.gameSoundFunction(num: 1)
                        let transition = SKTransition.fade(withDuration: 0.5)
                        let gameScene = MapScene(size: self.size)
                        gameScene.scaleMode = .aspectFill
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                    
                    if(tutorialButton.contains(positionInScene)){
                        self.gameSoundFunction(num: 1)
                        
                        let transition = SKTransition.fade(withDuration: 0.5)
                        let gameScene = TutorialScene(size: self.size)
                        gameScene.scaleMode = .aspectFill
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                    
                    if(optionButton.contains(positionInScene)){
                        self.gameSoundFunction(num: 1)
                        self.optionMenuFunction()
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func createScene(){
        let device_width = self.getTheDeviceSize().width
        
        game_layer = SKSpriteNode.init(imageNamed: "game_bg")
        game_layer.position = CGPoint.init(x: 0, y: 0)
        game_layer.size = CGSize.init(width: device_width, height: device_width*3/4)
        self.addChild(game_layer)
        
        let cloud_bg = SKSpriteNode.init(imageNamed: "bg_cloud")
        cloud_bg.position = CGPoint.init(x: 0, y: 0)
        cloud_bg.size = CGSize.init(width: device_width, height: device_width*3/4)
        cloud_bg.zPosition = 1
        game_layer.addChild(cloud_bg)
        
        let cloud_action1 = SKAction.move(by: CGVector.init(dx: 50, dy: 0), duration: 5)
        cloud_action1.timingMode = .easeInEaseOut
        let cloud_action2 = SKAction.move(by: CGVector.init(dx: -50, dy: 0), duration: 5)
        cloud_action2.timingMode = .easeInEaseOut
        let final_action = SKAction.repeatForever(SKAction.sequence([cloud_action1,cloud_action2]))
        cloud_bg.run(final_action)
        
        gameLabel = SKLabelNode.init(text: "Han Xin Counting Soldiers")
        gameLabel.position = CGPoint.init(x: 0, y: 110)
        self.setGameSceneLabel(item: gameLabel, type: 1, fsize: 66, pos: 2)
        gameLabel.zPosition = 10
        game_layer.addChild(gameLabel)
        
        startButton = SKLabelNode.init(text: "Start Game")
        startButton.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: startButton, type: 2, fsize: 40, pos: 2)
        startButton.zPosition = 10
        game_layer.addChild(startButton)
        /*
        modeButton = SKLabelNode.init(text: " Challenge Mode")
        modeButton.position = CGPoint.init(x: 0, y: -90)
        self.setGameSceneLabel(item: modeButton, type: 2, fsize: 40, pos: 2)
        modeButton.zPosition = 10
        game_layer.addChild(modeButton)*/
        
        tutorialButton = SKLabelNode.init(text: "Tutorial")
        tutorialButton.position = CGPoint.init(x: 0, y: -90)
        self.setGameSceneLabel(item: tutorialButton, type: 2, fsize: 40, pos: 2)
        tutorialButton.zPosition = 10
        game_layer.addChild(tutorialButton)
        
        optionButton = SKLabelNode.init(text: "Option")
        optionButton.position = CGPoint.init(x: 0, y: -180)
        self.setGameSceneLabel(item: optionButton, type: 2, fsize: 40, pos: 2)
        optionButton.zPosition = 10
        game_layer.addChild(optionButton)
        
        //============================== End Layer ==============================
        let layer_color = SKColor.init(red: 248/255, green: 245/255, blue: 236/255, alpha: 1)
        
        option_layer = SKSpriteNode.init(color: layer_color, size: CGSize.init(width: 450, height: 350))
        option_layer.position = CGPoint.init(x: 0, y: 0)
        option_layer.zPosition = 200
        option_layer.isHidden = true
        game_layer.addChild(option_layer)
        self.createRoundCornerOfLayer(layer: option_layer, length: 10)
        
        let optionlayer_toptext = SKLabelNode.init(text: "Option")
        optionlayer_toptext.position = CGPoint.init(x: 0, y: 120)
        self.setGameSceneLabel(item: optionlayer_toptext, type: 3, fsize: 40, pos: 2)
        option_layer.addChild(optionlayer_toptext)
        
        let optionlayer_soundtext = SKLabelNode.init(text: "Sound")
        optionlayer_soundtext.position = CGPoint.init(x: -100, y: 0)
        self.setGameSceneLabel(item: optionlayer_soundtext, type: 3, fsize: 30, pos: 2)
        option_layer.addChild(optionlayer_soundtext)
        
        let optionlayer_resettext = SKLabelNode.init(text: "Reset Game")
        optionlayer_resettext.position = CGPoint.init(x: -100, y: -100)
        self.setGameSceneLabel(item: optionlayer_resettext, type: 3, fsize: 30, pos: 2)
        option_layer.addChild(optionlayer_resettext)
        
        optionlayer_soundbtn = SKLabelNode.init(text: "On")
        optionlayer_soundbtn.position = CGPoint.init(x: 100, y: 0)
        self.setGameSceneLabel(item: optionlayer_soundbtn, type: 3, fsize: 36, pos: 2)
        option_layer.addChild(optionlayer_soundbtn)
        
        optionlayer_resetbtn = SKLabelNode.init(text: "Reset")
        optionlayer_resetbtn.position = CGPoint.init(x: 100, y: -100)
        self.setGameSceneLabel(item: optionlayer_resetbtn, type: 3, fsize: 36, pos: 2)
        option_layer.addChild(optionlayer_resetbtn)
        
        optionlayer_closebtn = SKSpriteNode.init(imageNamed: "close_btn")
        optionlayer_closebtn.position = CGPoint.init(x: 150, y: 150)
        optionlayer_closebtn.size = CGSize.init(width: 60, height: 60)
        option_layer.addChild(optionlayer_closebtn)
        
        //self.crtLogic()
    }
    
    //============================== Game Logic ==============================
    
    func optionMenuFunction(){
        if (optionOpen){
            optionOpen = false
            
            self.layerHideAnimation(layer: option_layer)
        }else{
            optionOpen = true
            
            self.layerShowAnimation(layer: option_layer)
        }
    }
    
    func layerShowAnimation(layer: SKSpriteNode){
        allowTouch = false
        layer.isHidden = false
        let scaleAction1 = SKAction.scale(to: 0.5, duration: 0)
        let scaleAction2 = SKAction.scale(to: 1.25, duration: 0.25)
        let scaleAction3 = SKAction.scale(to: 1, duration: 0.15)
    
        layer.run(SKAction.sequence([scaleAction1, scaleAction2, scaleAction3])){
            self.allowTouch = true
        }
    }
    
    func layerHideAnimation(layer: SKSpriteNode){
        allowTouch = false
        let scaleAction1 = SKAction.scale(to: 0.1, duration: 0.2)
        layer.run(scaleAction1){
            layer.isHidden = true
            self.allowTouch = true
        }
    }
    
    //============================== Basic Logic ==============================
    
    func createRoundCornerOfLayer(layer: SKSpriteNode, length: CGFloat){
        
        let set_size = CGSize.init(width: (length*2)+layer.size.width, height: (length*2)+layer.size.height)
        
        let round_shape = SKShapeNode.init(rectOf: set_size, cornerRadius: length)
        round_shape.position = CGPoint.init(x: 0, y: 0)
        round_shape.fillColor = layer.color
        round_shape.strokeColor = layer.color
        layer.addChild(round_shape)
    }
    
    func setGameSceneLabel(item: SKLabelNode, type: Int, fsize: Int, pos: Int){
        item.fontSize = CGFloat(fsize)
        item.verticalAlignmentMode = .center
        
        switch type {
        case 1:
            //================== Game Name Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
        case 2:
            //================== Game Button Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
        case 3:
            //================== Option Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.black
        default:
            break
        }
        
        switch pos {
        case 1:
            item.horizontalAlignmentMode = .left
        case 2:
            item.horizontalAlignmentMode = .center
        case 3:
            item.horizontalAlignmentMode = .right
        default:
            break
        }
    }
    
    func getTheDeviceSize()->CGSize{
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height{
            case 1792:
                print("iPhone XR")
                return CGSize.init(width: 1334, height: 616)
            case 2436:
                print("iPhone X")
                return CGSize.init(width: 1334, height: 616)
            case 2688:
                print("iPhone XS MAX")
                return CGSize.init(width: 1334, height: 616)
            default:
                return CGSize.init(width: 1334, height: 750)
            }
        }
        if UIDevice().userInterfaceIdiom == .pad{
            print("iPad")
            return CGSize.init(width: 1334, height: 1000)
        }
        return CGSize.init(width: 1334, height: 750)
    }
    
    func scaleTheGameLayer(){
        if UIDevice().userInterfaceIdiom == .pad{
            game_layer.xScale = 0.75
            game_layer.yScale = 0.75
        }
    }
    
    func gameSoundFunction(num: Int){
        if(soundOn){
            switch num {
            case 1:
                self.run(clickSound)
            default:
                break
            }
        }
    }
    
    //======================================== CRT Function ========================================
    
    func crtLogic(){
        for x in 12...100 {
            var temp_arr = [Int()]
            temp_arr.removeAll()
            
            let num_arr = [3,5,7,11]
            for num in num_arr{
                if(checkCrtFunction(num1: x, num2: num)){
                    temp_arr.append(num)
                    if(temp_arr.count == 3){
                        break
                    }
                }
            }
            if(temp_arr.count > 2 && temp_arr != [3,5,7]){
                let realnum = calAnswerFunction(num: x, num1: temp_arr[0], num2: temp_arr[1], num3: temp_arr[2])
                print("\(realnum) \(temp_arr[0]) \(temp_arr[1]) \(temp_arr[2])")
            }
        }
    }
    
    func checkCrtFunction(num1: Int, num2: Int)->Bool{
        if(num1%num2 == 0 || num1%num2>7){
            return false
        }
        return true
    }
    
    func calAnswerFunction(num: Int, num1: Int, num2: Int, num3: Int)->Int{
        let num_arr = [num1, num2, num3]
        var tempnum_arr = [Int()]
        tempnum_arr.removeAll()
        
        let them = num1*num2*num3
        var add_num = 0
        
        for x in 0...2 {
            tempnum_arr.removeAll()
            for y in 0...2{
                if(x != y){
                    tempnum_arr.append(num_arr[y])
                }
            }
            
            var temp_num = 1
            for num in tempnum_arr{
                temp_num *= num
            }
            
            var set_num = temp_num
            var count_multi = 1
            
            while(set_num%num_arr[x] != 1){
                set_num += temp_num
                count_multi += 1
            }
            let thenum = num%num_arr[x]
            add_num += (set_num*thenum)
        }
        let multi_num = add_num/them
        let final_num = add_num-(multi_num*them)
        //print("the num \(add_num) - \(final_num)")
        
        return final_num
    }
    
    //======================================== Save Data ========================================
    func getDataFunction(){
        
        if(isKeyPresentInUserDefaults(key: "curLang") == false){
            gameDefault.set(0, forKey: "curLang")
            /* 0: EN , 1: SC , 2: TC */
        }else{
            theLang = gameDefault.integer(forKey: "curLang")
        }
        
        if(isKeyPresentInUserDefaults(key: "soundStat") == false){
            gameDefault.set(true, forKey: "soundStat")
        }else{
            soundOn = gameDefault.bool(forKey: "soundStat")
        }
    }
    
    func updateGameSoundFunction(){
        if(soundOn == true){
            soundOn = false
        }else{
            soundOn = true
        }
        
        if(soundOn == true){
            optionlayer_soundbtn.text = "On"
        }else{
            optionlayer_soundbtn.text = "Off"
        }
    }
    
    func resetMapNumberFunction(){
        gameDefault.set(1, forKey: "playerLevel")
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
