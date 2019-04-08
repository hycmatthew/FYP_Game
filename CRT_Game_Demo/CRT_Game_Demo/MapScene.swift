//
//  MapScene.swift
//  CRT_Game_Demo
//
//  Created by Matthew Chan on 14/2/2019.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

import SpriteKit
import GameplayKit

class MapScene: SKScene {
    let gameDefault = UserDefaults.standard
    var theLang = 0
    var soundOn = true
    var player_level = 1
    
    var game_layer = SKSpriteNode()
    var isOptionShow = false
    
    var place_arr = [SKSpriteNode()]
    var option_layer = SKSpriteNode()
    var option_btn = SKSpriteNode()
    var sound_btn = SKSpriteNode()
    var menu_btn = SKSpriteNode()
    
    //==================== Game Data Setting ====================
    let map_nama_arr = ["Yong", "Zhai", "Sai", "Wei", "Dai", "Zhao", "Qi", "Chu"]
    
    var halfWidth:CGFloat = 0
    var halfHeight:CGFloat = 0
    let soundOn_img = SKTexture.init(imageNamed: "sound_on")
    let soundOff_img = SKTexture.init(imageNamed: "sound_off")
    
    //==================== Sound Action Setting ====================
    let clickSound = SKAction.playSoundFileNamed("sound_click.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
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
        for t in touches {
            let positionInScene = t.location(in: game_layer)
            let positionInOption = t.location(in: option_layer)
            
            if(option_btn.contains(positionInOption)){
                self.showGameMenuLogic()
            }
            if(sound_btn.contains(positionInOption)){
                self.gameSoundFunction(num: 1)
                self.updateGameSoundFunction()
            }
            if(menu_btn.contains(positionInOption)){
                self.gameSoundFunction(num: 1)
                let transition = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: transition)
            }
            
            for item in place_arr{
                if(item.contains(positionInScene)){
                    self.gameSoundFunction(num: 1)
                    gameDefault.set(Int(item.zPosition), forKey: "curLevel")
                    
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = MainScene(size: self.size)
                    gameScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //============================== Create Scene ==============================
    
    func createScene(){
        halfWidth = self.getTheDeviceSize().width/2
        halfHeight = self.getTheDeviceSize().height/2
        let winWidth = self.size.width
        let winHeight = self.size.height
        
        var reset_posy = CGFloat(0)
        
        if UIDevice().userInterfaceIdiom == .phone{
            reset_posy = -100
        }
        
        let map_pos_arr = [CGPoint.init(x:-300, y: 150), CGPoint.init(x: -150, y: 130), CGPoint.init(x:-150, y: 250), CGPoint.init(x: 0, y: 225), CGPoint.init(x: 75, y: 375), CGPoint.init(x: 150, y: 250), CGPoint.init(x: 290, y: 210), CGPoint.init(x: 250, y: 100)]
        
        game_layer = SKSpriteNode.init(color: SKColor.white, size: self.getTheDeviceSize())
        game_layer.position = CGPoint.init(x: winWidth/2, y: winHeight/2)
        game_layer.zPosition = 0
        self.addChild(game_layer)
        
        let the_map = SKSpriteNode.init(imageNamed: "map")
        the_map.position = CGPoint.init(x: 0, y: reset_posy)
        game_layer.addChild(the_map)
        
        option_layer = SKSpriteNode.init(color: .clear, size: CGSize.init(width: 50, height: 50))
        option_layer.position = CGPoint.init(x: halfWidth-50, y: halfHeight-50)
        option_layer.zPosition = 10
        game_layer.addChild(option_layer)
        
        option_btn = SKSpriteNode.init(imageNamed: "option_icon")
        option_btn.position = CGPoint.init(x: 0, y: 0)
        option_btn.size = CGSize.init(width: 45, height: 45)
        option_btn.zPosition = 1
        option_layer.addChild(option_btn)
        
        sound_btn = SKSpriteNode.init(texture: soundOff_img)
        sound_btn.position = CGPoint.init(x: 100, y: 0)
        sound_btn.size = CGSize.init(width: 40, height: 40)
        sound_btn.zPosition = 1
        option_layer.addChild(sound_btn)
        if(soundOn){
           sound_btn.texture = soundOn_img
        }
        
        menu_btn = SKSpriteNode.init(imageNamed: "home_btn")
        menu_btn.position = CGPoint.init(x: 200, y: 0)
        menu_btn.size = CGSize.init(width: 40, height: 40)
        menu_btn.zPosition = 1
        option_layer.addChild(menu_btn)
        
        for x in 0...map_pos_arr.count-1{
            
            let map_label = SKLabelNode.init(text: map_nama_arr[x])
            map_label.position = CGPoint.init(x: map_pos_arr[x].x, y: map_pos_arr[x].y+50+reset_posy)
            self.setGameSceneLabel(item: map_label, type: 2, fsize: 40, pos: 2)
            map_label.zPosition = 10
            game_layer.addChild(map_label)
            
            let place_icon = SKSpriteNode.init(imageNamed: "place_btn")
            place_icon.position = CGPoint.init(x: map_pos_arr[x].x, y: map_pos_arr[x].y+reset_posy)
            place_icon.size = CGSize.init(width: 50, height: 50)
            place_icon.zPosition = 50
            game_layer.addChild(place_icon)
            
            if(x<player_level){
                let place_back = SKSpriteNode.init(imageNamed: "place_button_bg")
                place_back.position = CGPoint.init(x: map_pos_arr[x].x, y: map_pos_arr[x].y+reset_posy)
                place_back.size = CGSize.init(width: 50, height: 50)
                place_back.zPosition = CGFloat(x)+1
                game_layer.addChild(place_back)
                place_arr.append(place_back)
                
                let scale_action1 = SKAction.scale(to: CGSize.init(width: 100, height: 100), duration: 2)
                let scale_action2 = SKAction.scale(to: CGSize.init(width: 50, height: 50), duration: 2)
                place_back.run(SKAction.repeatForever(SKAction.sequence([scale_action1, scale_action2])))
            }
        }
        
        self.scaleTheGameLayer()
    }
    
    //============================== Game Logic ==============================
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
    
    //============================== Basic Logic ==============================
    func setGameSceneLabel(item: SKLabelNode, type: Int, fsize: Int, pos: Int){
        item.fontSize = CGFloat(fsize)
        item.verticalAlignmentMode = .center
        
        switch type {
        case 1:
            //================== Area Top Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.init(red: 155/255, green: 145/255, blue: 135/255, alpha: 1)
        case 2:
            //================== Area Top Text ==================
            item.fontName = "ArialRoundedMTBold"
            item.fontColor = SKColor.white
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
        
        if(isKeyPresentInUserDefaults(key: "playerLevel") == false){
            gameDefault.set(1, forKey: "playerLevel")
        }else{
            player_level = gameDefault.integer(forKey: "playerLevel")
        }
    }
    
    func updateGameSoundFunction(){
        if(soundOn == true){
            soundOn = false
        }else{
            soundOn = true
        }
        
        if(soundOn == true){
            sound_btn.texture = soundOn_img
        }else{
            sound_btn.texture = soundOff_img
        }
        gameDefault.set(soundOn, forKey: "soundStat")
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
