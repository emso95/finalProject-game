import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var panGesture = UIPanGestureRecognizer()
    var game = GameHelper.sharedInstance
    var verticalCameraNode: SCNNode!
    var ballNode: SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    func setupScene() {
        scnView = self.view as! SCNView
        scnView.delegate = self
        
        scnScene = SCNScene(named: "GeometryFighter.scnassets/Scene/model.scn")
        scnView.scene = scnScene
        scnView.showsStatistics = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.shootBall(_:)))
        scnView.addGestureRecognizer(panGesture)
    }
    
    func setupNodes() {
        
        verticalCameraNode = scnScene.rootNode.childNode(withName: "cameraa", recursively: true)!
        
        scnScene.rootNode.addChildNode(game.hudNode)
        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively:
            true)!
    }
    
    func setupSounds() {
    }
    
    override var shouldAutorotate: Bool { return true }
    
    override var prefersStatusBarHidden: Bool { return false }
    
    @objc func shootBall(_ sender: UIPanGestureRecognizer){
        var startLocation = CGPoint()
        if(sender.state == UIGestureRecognizer.State.began){
            startLocation = sender.location(in: self.view)
        }
        else if (sender.state == UIGestureRecognizer.State.ended) {
            let stopLocation = sender.location(in: self.view)
            let dx = stopLocation.x - startLocation.x;
            let dy = stopLocation.y - startLocation.y;
            let distance = sqrt(dx*dx + dy*dy );
            print("Distance: %f", distance);
            
            if distance > 150 {
                let force = SCNVector3(x: 0, y: 50 , z: -400)
                // 3
                let position = SCNVector3(x: 0, y: 0, z: 0)
                // 4
                ballNode.physicsBody?.applyForce(force,at: position, asImpulse: true)
            }
        }
    
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        game.updateHUD()
        if ballNode.position.y < -2133{
            if ballNode.position.y < 95 && ballNode.position.x<4054 && ballNode.position.x<4300{
                print("Goal!")
            }
            else{
                print("No Goal!")
            }
            ballNode.removeFromParentNode()
            ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively:
                true)!
        }
        
        
    }
}
