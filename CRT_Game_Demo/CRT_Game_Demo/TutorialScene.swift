//
//  TutorialScene.swift
//  CRT_Game_Demo
//
//  Created by Matthew Chan on 18/2/2019.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialScene: SKScene{
    var game_layer = SKSpriteNode()
    var alpha_layer = SKSpriteNode()
    
    var stat_layer = SKSpriteNode()
    var level_label = SKLabelNode()
    var play_button = SKSpriteNode()
    
    var text1_layer = SKSpriteNode()
    var text2_layer = SKSpriteNode()
    var text3_layer = SKSpriteNode()
    var text1_label = SKLabelNode()
    var text2_label = SKLabelNode()
    var text3_label = SKLabelNode()
    
    var tutor_layer = SKSpriteNode()
    var tutor_text1 = SKLabelNode()
    var tutor_text2 = SKLabelNode()
    var tutor_text3 = SKLabelNode()
    
    var option_layer = SKSpriteNode()
    var optionlayer_optionbtn = SKSpriteNode()
    var optionlayer_soundbtn = SKSpriteNode()
    var optionlayer_menubtn = SKSpriteNode()
    
    var layer_arr = [SKSpriteNode()]
    var highlight_arr = [SKSpriteNode()]
    var answer_num = 23
    var remain_arr = [Int()]
    
    var player_arr = [GameSprite()]
    var enemy_arr = [GameSprite()]
    //==================== Number Setting ====================
    let gameDefault = UserDefaults.standard
    var theLang = 0
    var soundOn = true
    
    var allowTouch = false
    var isPassLevel = false
    var isOptionShow = false
    var tutor_num = 0
    
    //==================== Game Data Setting ====================
    let soundOn_img = SKTexture.init(imageNamed: "sound_on")
    let soundOff_img = SKTexture.init(imageNamed: "sound_off")
    let win_texture = SKTexture.init(imageNamed: "pass_icon")
    let lose_texture = SKTexture.init(imageNamed: "fail_icon")
    
    var halfWidth:CGFloat = 0
    var halfHeight:CGFloat = 0
    let layer_posy = CGFloat(200)
    let layer_width = 600
    
    //==================== Sound Action Setting ====================
    let clickSound = SKAction.playSoundFileNamed("sound_click.wav", waitForCompletion: false)
    let moveSound = SKAction.playSoundFileNamed("sound_move.wav", waitForCompletion: false)
    let failSound = SKAction.playSoundFileNamed("sound_fail.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.white
        
        self.getDataFunction()
        
        layer_arr.removeAll()

        self.createGameScene()
        self.setMathLogic()
        self.gameStartAnimation()
        self.scaleTheGameLayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(allowTouch){
            for t in touches {
                let positionInScene = t.location(in: game_layer)
                
                if(play_button.isHidden == true && tutor_layer.contains(positionInScene)){
                    self.tutorialAnimation()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let positionInScene = t.location(in: game_layer)
            let positionInOption = t.location(in: option_layer)
            
            if(optionlayer_optionbtn.contains(positionInOption)){
                self.showGameMenuLogic()
            }
            if(optionlayer_soundbtn.contains(positionInOption)){
                self.gameSoundFunction(num: 1)
                self.updateGameSoundFunction()
            }
            if(optionlayer_menubtn.contains(positionInOption)){
                self.gameSoundFunction(num: 1)
                self.backToMenuScene()
            }
            if(play_button.contains(positionInScene)){
                self.gameSoundFunction(num: 1)
                self.moveToGameSceneFunction()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //============================== Set Scene ==============================
    func createGameScene(){
        halfWidth = self.getTheDeviceSize().width/2
        halfHeight = self.getTheDeviceSize().height/2
        
        game_layer = SKSpriteNode.init(color: SKColor.white, size: self.getTheDeviceSize())
        game_layer.position = CGPoint.init(x: 0, y: 0)
        game_layer.zPosition = 0
        self.addChild(game_layer)
        
        alpha_layer = SKSpriteNode.init(color: .white, size: self.getTheDeviceSize())
        alpha_layer.alpha = 0.7
        alpha_layer.position = CGPoint.init(x: 0, y: 0)
        alpha_layer.zPosition = 500
        alpha_layer.isHidden = true
        self.addChild(alpha_layer)
        
        let device_width = self.getTheDeviceSize().width
        
        let background = SKSpriteNode.init(imageNamed: "game_bg")
        background.position = CGPoint.init(x: 0, y: 0)
        background.size = CGSize.init(width: device_width, height: device_width*3/4)
        background.zPosition = 0
        game_layer.addChild(background)
        
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
        
        //============================== Top Layer ==============================
        stat_layer = SKSpriteNode.init(color: SKColor.clear, size: CGSize.init(width: self.size.width, height: 50))
        stat_layer.position = CGPoint.init(x: 0, y: halfHeight-25)
        stat_layer.zPosition = 100
        game_layer.addChild(stat_layer)
        
        level_label = SKLabelNode.init(text: "Qin - Level 1")
        level_label.position = CGPoint.init(x: 100-halfWidth, y: 0)
        self.setGameSceneLabel(item: level_label, type: 2, fsize: 24, pos: 2)
        stat_layer.addChild(level_label)
        
        //============================== Main Game Scene ==============================
        let layer_pos_x = 350-halfWidth
        
        text1_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 90))
        text1_layer.alpha = 0.9
        text1_layer.position = CGPoint.init(x: layer_pos_x, y: layer_posy)
        text1_layer.zPosition = 100
        game_layer.addChild(text1_layer)
        layer_arr.append(text1_layer)
        
        text2_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 90))
        text2_layer.alpha = 0.9
        text2_layer.position = CGPoint.init(x: layer_pos_x, y: text1_layer.position.y-130)
        text2_layer.zPosition = 100
        game_layer.addChild(text2_layer)
        layer_arr.append(text2_layer)
        
        text3_layer = SKSpriteNode.init(color: .darkGray, size: CGSize.init(width: layer_width, height: 90))
        text3_layer.alpha = 0.9
        text3_layer.position = CGPoint.init(x: layer_pos_x, y: text2_layer.position.y-130)
        text3_layer.zPosition = 100
        game_layer.addChild(text3_layer)
        layer_arr.append(text3_layer)
        
        text1_label = SKLabelNode.init(text: " ")
        text1_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: text1_label, type: 3, fsize: 20, pos: 2)
        text1_label.zPosition = 10
        text1_layer.addChild(text1_label)
        
        text2_label = SKLabelNode.init(text: " ")
        text2_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: text2_label, type: 3, fsize: 20, pos: 2)
        text2_label.zPosition = 10
        text2_layer.addChild(text2_label)
        
        text3_label = SKLabelNode.init(text: " ")
        text3_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: text3_label, type: 3, fsize: 20, pos: 2)
        text3_label.zPosition = 10
        text3_layer.addChild(text3_label)
        
        play_button = SKSpriteNode.init(imageNamed: "submit_btn")
        play_button.position = CGPoint.init(x: layer_pos_x+600, y: 0)
        play_button.size = CGSize.init(width: 80, height: 80)
        play_button.isHidden = true
        play_button.zPosition = 10
        game_layer.addChild(play_button)
        
        //============================== Tutorial Layer ==============================
        let layer_color = SKColor.init(red: 248/255, green: 245/255, blue: 236/255, alpha: 1)
        
        tutor_layer = SKSpriteNode.init(color: layer_color, size: CGSize.init(width: 480, height: 280))
        tutor_layer.position = CGPoint.init(x: layer_pos_x+600, y: 0)
        tutor_layer.zPosition = 100
        tutor_layer.isHidden = true
        game_layer.addChild(tutor_layer)
        
        let result_shape = SKShapeNode.init(rectOf: CGSize.init(width: tutor_layer.size.width+20, height: tutor_layer.size.height+20), cornerRadius: 10)
        result_shape.position = CGPoint.init(x: 0, y: 0)
        result_shape.fillColor = layer_color
        result_shape.strokeColor = layer_color
        tutor_layer.addChild(result_shape)
        
        tutor_text1 = SKLabelNode.init(text: " ")
        tutor_text1.position = CGPoint.init(x: 0, y: 80)
        self.setGameSceneLabel(item: tutor_text1, type: 11, fsize: 28, pos: 2)
        tutor_text1.zPosition = 10
        tutor_layer.addChild(tutor_text1)
        
        tutor_text2 = SKLabelNode.init(text: " ")
        tutor_text2.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: tutor_text2, type: 11, fsize: 28, pos: 2)
        tutor_text2.zPosition = 10
        tutor_layer.addChild(tutor_text2)
        
        tutor_text3 = SKLabelNode.init(text: " ")
        tutor_text3.position = CGPoint.init(x: 0, y: -80)
        self.setGameSceneLabel(item: tutor_text3, type: 11, fsize: 28, pos: 2)
        tutor_text3.zPosition = 10
        tutor_layer.addChild(tutor_text3)
        
        //============================== Pause Layer ==============================
        option_layer = SKSpriteNode.init(color: .clear, size: CGSize.init(width: 50, height: 50))
        option_layer.position = CGPoint.init(x: halfWidth-50, y: halfHeight-50)
        option_layer.zPosition = 200
        game_layer.addChild(option_layer)
        
        optionlayer_optionbtn = SKSpriteNode.init(imageNamed: "option_icon")
        optionlayer_optionbtn.position = CGPoint.init(x: 0, y: 0)
        optionlayer_optionbtn.size = CGSize.init(width: 45, height: 45)
        optionlayer_optionbtn.zPosition = 1
        option_layer.addChild(optionlayer_optionbtn)
        
        optionlayer_soundbtn = SKSpriteNode.init(texture: soundOff_img)
        optionlayer_soundbtn.position = CGPoint.init(x: 100, y: 0)
        optionlayer_soundbtn.size = CGSize.init(width: 40, height: 40)
        optionlayer_soundbtn.zPosition = 1
        option_layer.addChild(optionlayer_soundbtn)
        if(soundOn){
            optionlayer_soundbtn.texture = soundOff_img
        }
        
        optionlayer_menubtn = SKSpriteNode.init(imageNamed: "home_btn")
        optionlayer_menubtn.position = CGPoint.init(x: 200, y: 0)
        optionlayer_menubtn.size = CGSize.init(width: 40, height: 40)
        optionlayer_menubtn.zPosition = 1
        option_layer.addChild(optionlayer_menubtn)
    }
    
    func soldierResetFunction(){
        for item in player_arr {
            item.setPlayerPosition(win_width: halfWidth)
        }
        for item in enemy_arr {
            item.setEnemyPosition(win_width: halfWidth)
        }
    }
    
    //============================== Game Logic ==============================
    
    func moveToGameSceneFunction(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = MapScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func backToMenuScene(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    //============================== Update Game Logic ==============================
    
    func pauseTimerFunction(){
        self.removeAction(forKey: "time_action")
    }
    
    func showGameItemFunction(){
        self.showEquationAnimation()
    }
    
    func hideGameItemFunction(){
        
        for item in layer_arr {
            item.isHidden = true
        }
    }
    
    //============================== Set Math Logic ==============================
    
    func setMathLogic(){
        let num_arr = [3,5,7]
        remain_arr.removeAll()
        
        for item in num_arr{
            let remainder = 23%item
            remain_arr.append(remainder)
        }
        
        text1_label.text = "When the solders stood 3 in a row, there were \(remain_arr[0]) left over."
        text2_label.text = "When the solders stood 5 in a row, there were \(remain_arr[1]) left over."
        text3_label.text = "When the solders stood 7 in a row, there were \(remain_arr[2]) left over."
    }
    
    
    //============================== Game Animation ==============================
    
    func gameStartAnimation(){
        self.hideGameItemFunction()
        stat_layer.isHidden = true
        
        let start_label = SKLabelNode.init(text: "Tutorial")
        start_label.position = CGPoint.init(x: 0, y: 0)
        self.setGameSceneLabel(item: start_label, type: 1, fsize: 72, pos: 2)
        start_label.zPosition = 100
        self.addChild(start_label)
        
        let waitAction = SKAction.wait(forDuration: 2)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        start_label.run(SKAction.sequence([waitAction, fadeOut])){
            self.allowTouch = true
            self.stat_layer.isHidden = false
            self.tutorialAnimation()
            self.showEquationAnimation()
        }
    }
    
    func tutorialAnimation(){
        self.layerShowAnimation(layer: tutor_layer)
        tutor_num += 1
        switch tutor_num {
        case 1:
            tutor_text1.text = "Remember the divisors"
            tutor_text2.text = "3, 5, 7"
            tutor_text3.text = "3x5x7=105"
        case 2:
            tutor_text1.text = "The remainder divide by 3 is 2"
            tutor_text2.text = "70x2=140"
            tutor_text3.text = ""
        case 3:
            tutor_text1.text = "The remainder divide by 5 is 3"
            tutor_text2.text = "21x3=63"
            tutor_text3.text = ""
        case 4:
            tutor_text1.text = "The remainder divide by 7 is 2"
            tutor_text2.text = "15x2=30"
            tutor_text3.text = ""
        case 5:
            tutor_text1.text = "Add above 3 numbers"
            tutor_text2.text = "140+63+30=233"
            tutor_text3.text = ""
        case 6:
            tutor_text1.text = "Subtract 105 when the number>105"
            tutor_text2.text = "233-105-105=23"
            tutor_text3.text = "23 is the answer!"
        case 7:
            play_button.isHidden = false
            tutor_layer.isHidden = true
        default:
            break
        }
    }
    
    func showEquationAnimation(){
        for x in 0...2{
            layer_arr[x].isHidden = false
            layer_arr[x].position.y = layer_posy
            let set_pos = CGPoint.init(x: 350-halfWidth, y: layer_posy-(CGFloat(x)*(layer_arr[x].size.height+10)))
            let move_action = SKAction.move(to: set_pos, duration: 0.25*Double(x))
            layer_arr[x].run(move_action)
        }
    }
    func gameEndAnimation(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = MapScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func showGameMenuLogic(){
        if(isOptionShow){
            let moveAction = SKAction.move(to: CGPoint.init(x: halfWidth-50, y: halfHeight-50), duration: 0.7)
            moveAction.timingMode = .easeInEaseOut
            option_layer.run(moveAction){
                self.isOptionShow = false
            }
        }else{
            let moveAction = SKAction.move(to: CGPoint.init(x: halfWidth-250, y: halfHeight-50), duration: 0.7)
            moveAction.timingMode = .easeInEaseOut
            option_layer.run(moveAction){
                self.isOptionShow = true
            }
        }
    }
    
    func layerShowAnimation(layer: SKSpriteNode){
        layer.isHidden = false
        let scaleAction1 = SKAction.scale(to: 0.75, duration: 0)
        let scaleAction2 = SKAction.scale(to: 1.20, duration: 0.25)
        let scaleAction3 = SKAction.scale(to: 1, duration: 0.15)
        
        layer.run(SKAction.sequence([scaleAction1, scaleAction2, scaleAction3]))
    }
    
    func layerHideAnimation(layer: SKSpriteNode){
        let scaleAction1 = SKAction.scale(to: 0.1, duration: 0.2)
        layer.run(scaleAction1){
            layer.isHidden = true
        }
    }
    
    //============================== Basic Logic ==============================
    func setGameSceneLabel(item: SKLabelNode, type: Int, fsize: Int, pos: Int){
        item.fontSize = CGFloat(fsize)
        item.verticalAlignmentMode = .center
        
        switch type {
        case 1:
            //================== Game Start Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.black
        case 2:
            //================== Area Top Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.black
            item.horizontalAlignmentMode = .left
        case 3:
            //================== Equation Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
        case 11:
            //================== Hints Layer ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.init(red: 166/255, green: 149/255, blue: 141/255, alpha: 1)
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
            case 2:
                self.run(clickSound)
            case 3:
                self.run(failSound)
            default:
                break
            }
        }
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
            optionlayer_soundbtn.texture = soundOn_img
        }else{
            optionlayer_soundbtn.texture = soundOff_img
        }
        gameDefault.set(soundOn, forKey: "soundStat")
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

