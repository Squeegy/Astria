head.js(
  # libs
  'lib/three.js'
  'lib/RequestAnimationFrame.js'
  'lib/underscore.js'
  
  # Support
  'util.js'
  'orbit_camera.js'
  
  # Astria Core
  'game.js'
  'artifact.js'
  
  # Levels
  'artifacts/test1.js'
  
  # All loaded callback
  ->
    Game.game = new Game()
    Game.game.animate()
)