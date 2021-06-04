//
//  GameScene2.swift
//  SpaceFlappy
//
//  Created by user on 05.02.2021.
//  Copyright © 2021 MacBook Air. All rights reserved.
//

import SpriteKit

class GameScene2: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var sprite: SKSpriteNode!
    var battery: SKSpriteNode!
    var shield: SKEmitterNode!
    var gameTimer: Timer?
    var batteryTimer: Timer?
    var isGameStarted = false
    var cheat = false
    var isGameOver = false
    var shieldIsActive = false
    var meteors = 0
    var y = [50, 150, 250, 350, 450, 550, 650, 750, 850]
    var batPos = [100, 400, 650]
    var pos = [Int]()
    var meteorSpeed = -300
    var meteorsYSpeed = [0,0,0, 200]
    override func didMove(to view: SKView) {
           
        physicsWorld.contactDelegate = self
        backgroundColor = .black
        starfield = SKEmitterNode(fileNamed: "starfield2")!
        starfield.position = CGPoint(x: 414, y: 450)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "spaceshipFlap")
        player.name = "player"
        player.size = CGSize(width: 75, height: 75)
        player.position = CGPoint(x: 60, y: 450)
        player.physicsBody = SKPhysicsBody(circleOfRadius: 85 / 2)
        player.physicsBody?.contactTestBitMask = 1
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: -42, y: 0)
            emitter.zRotation = 1.57
            emitter.zPosition = -0.5
            emitter.particleRotation = 0.2
            player.addChild(emitter)
        }
        
        if let shield = SKEmitterNode(fileNamed: "shield") {
            shield.position = CGPoint(x: 0, y: 0)
//            emitter2.zRotation = 1.57
            shield.zPosition = -0.5
            player.addChild(shield)
            shieldIsActive = true
            
        }
        
        addChild(player)
        
    }
    
    func startGame() {
        isGameStarted = true
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        batteryTimer = Timer.scheduledTimer(timeInterval: 35, target: self, selector: #selector(createBattery), userInfo: nil, repeats: true)
        
    }
    
    @objc func createBattery() {
        battery = SKSpriteNode(imageNamed: "battery")
        battery.name = "battery"
        battery.size = CGSize(width: 50, height: 70)
        battery.physicsBody = SKPhysicsBody(rectangleOf: battery.size)
        battery.position = CGPoint(x: 540, y: batPos.randomElement()!)
        battery.physicsBody?.categoryBitMask = 1
        battery.physicsBody?.collisionBitMask = 1
        battery.physicsBody?.contactTestBitMask = 1
        battery.physicsBody?.linearDamping = 0
        battery.physicsBody?.angularDamping = 0
        battery.physicsBody?.angularVelocity = 3
        battery.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
        battery.physicsBody?.affectedByGravity = false
        addChild(battery)
    }
    
    @objc func createEnemy() {
        
        y.shuffle()
        let Y = y[0]
        y.removeFirst()
        pos.append(Y)
        if y.count == 0 {
            y = pos
            pos.removeAll()
        }
    
        sprite = SKSpriteNode(imageNamed: "meteorite")
        sprite.name = "meteor"
        sprite.size = CGSize(width: 100, height: 100)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        sprite.position = CGPoint(x: 540, y: Y)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.collisionBitMask = 1
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.angularVelocity = 3
        sprite.physicsBody?.velocity = CGVector(dx: meteorSpeed, dy: 0)
        sprite.physicsBody?.affectedByGravity = false
        addChild(sprite)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameStarted {
            startGame()
            print("StartGame")
            viewController.tapLabel.isHidden = true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 50 {
            location.y = 50
        } else if location.y > 896 {
            location.y = 896
        }

        if !cheat  {
            player.position = CGPoint(x: location.x, y: location.y + 70)
        } else if location.y - player.position.y < 50 && location.x - player.position.x < 50 &&  player.position.x - location.x < 50 &&  player.position.y - location.y < 50   {
            player.position = CGPoint(x: location.x, y: location.y + 70)
            cheat = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cheat = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "player" {
            collisionBetween(player: nodeA, object: nodeB)
//            gameTimer?.invalidate()
        } else if nodeB.name == "player" {
            collisionBetween(player: nodeB, object: nodeA)
//            gameTimer?.invalidate()
        }
    }
    
    func collisionBetween(player: SKNode, object: SKNode) {
        
        if object.name == "gun" {
            object.removeFromParent()
            
            let gun = SKAction.setTexture(SKTexture(imageNamed:"GunShip"))
            childNode(withName: "player")?.run(gun)
        }
        
        if shieldIsActive {
            if object.name == "meteor" {
                object.removeFromParent()
                let explosion = SKEmitterNode(fileNamed: "explosion")!
                explosion.position = object.position
                addChild(explosion)
                player.removeAllChildren()
                if let emitter = SKEmitterNode(fileNamed: "fuse") {
                    emitter.position = CGPoint(x: -42, y: 0)
                    emitter.zRotation = 1.57
                    emitter.zPosition = -0.5
                    emitter.particleRotation = 0.2
                    player.addChild(emitter)
                }
                player.physicsBody  = SKPhysicsBody(circleOfRadius: 75 / 2)
                shieldIsActive = false
            } else if object.name == "battery" {
                object.removeFromParent()
            }
            
        } else {
            if object.name == "meteor" {
                isGameOver = true
                gameTimer?.invalidate()
                isGameStarted = false
                player.removeFromParent()
                let explosion = SKEmitterNode(fileNamed: "explosion")!
                explosion.position = player.position
                addChild(explosion)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let newGame = GameScene2(size: self.size)
                    newGame.viewController = self.viewController
                    let transition = SKTransition.doorway(withDuration: 1.5)
                    self.view?.presentScene(newGame, transition: transition)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.viewController.playButton.isHidden = false
                        self.viewController.nameLabel.isHidden = false
                        self.viewController.nameText.isHidden = false
    
                    }
                }
            } else if object.name == "battery" {
                object.removeFromParent()
                player.physicsBody = SKPhysicsBody(circleOfRadius: 85 / 2)
                if let shield = SKEmitterNode(fileNamed: "shield") {
                    shield.position = CGPoint(x: 0, y: 0)
        //            emitter2.zRotation = 1.57
                    shield.zPosition = -0.5
                    player.addChild(shield)
                    shieldIsActive = true
                }
                
            }
        }
            
    }
    
    override func update(_ currentTime: TimeInterval) {
        meteors += 1
        if !isGameOver && isGameStarted {
            
//            if meteors == 200 {
//                gameTimer?.invalidate()
//                gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//                meteorSpeed = -350
//                print("Yea")
//            }
//
//            if meteors == 500 {
//                gameTimer?.invalidate()
//                gameTimer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//                meteorSpeed = -650
//                print("Yea2")
//            }
//
//            if meteors == 1000 {
//                gameTimer?.invalidate()
//                gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//                meteorSpeed = -1000
//                print("Yea3")
            }
            
            if meteors == 200 {
                
                gameTimer?.invalidate()
                let gun = SKSpriteNode(imageNamed: "Gun")
                gun.name = "gun"
                gun.size = CGSize(width: 90, height: 75)
                gun.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 20))
                gun.position = CGPoint(x: 540, y:  450)
                gun.physicsBody?.categoryBitMask = 1
                gun.physicsBody?.collisionBitMask = 2
                gun.physicsBody?.contactTestBitMask = 1
                gun.physicsBody?.linearDamping = 0
                gun.physicsBody?.angularDamping = 0
                gun.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
                gun.physicsBody?.affectedByGravity = false
                addChild(gun)
                
            
        }
        
        for node in children {
            if node.position.x < -200 {
                node.removeFromParent()
            }
        }
    }
    
}
