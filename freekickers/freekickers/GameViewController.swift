import UIKit
import SceneKit


class GameViewController: UIViewController {
    var isShot=false;
    var ballPosition: SCNVector3!
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
        
        scnScene = SCNScene(named: "freekickerArt.scnassets/Scene/model.scn")
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
        ballPosition =  ballNode.position
    }
    
    func setupSounds() {
    }
    func resetGame(){
        ballNode.physicsBody!.velocity = SCNVector3Zero
        ballNode.position = ballPosition
        
    }
    
    override var shouldAutorotate: Bool { return true }
    
    override var prefersStatusBarHidden: Bool { return false }
    
    @objc func shootBall(_ sender: UIPanGestureRecognizer){
        var startLocation = CGPoint()
        if(!isShot){
            if(sender.state == UIGestureRecognizer.State.began){
                startLocation = sender.location(in: self.view)
            }
            else if (sender.state == UIGestureRecognizer.State.ended) {
                let stopLocation = sender.location(in: self.view)
                let dx = stopLocation.x - startLocation.x;
                let dy = stopLocation.y - startLocation.y;
                let distance = sqrt(dx*dx + dy*dy );
            
            
                let force = SCNVector3(x: 0, y: 0 , z: Float(-2*(distance)))
            
                let position = SCNVector3(x: 0, y: 0, z: 0)
                ballNode.physicsBody?.applyForce(force, asImpulse: true)
                
            
            }
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        game.updateHUD()
        if ballNode.presentation.position.z < -2133{
            if ballNode.presentation.position.y < 95 && ballNode.presentation.position.x > 4054 && ballNode.presentation.position.x < 4300{
                print("Goal!")
            }
            else{
                print("No Goal!")
            }
           resetGame()
        }
    }
}
