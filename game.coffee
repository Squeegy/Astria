Game =
  init: ->
    # Camera
    @camera = new OrbitCamera(75, window.innerWidth / window.innerHeight, 1, 10000)    
    @cameraOrbiting = off
    
    # Scene
    @scene = new THREE.Scene()
    
    # Lights
    light = new THREE.DirectionalLight(0xffffff, 1.0, 500)
    light.position.set(0, 1, 0.25)
    @scene.addObject(light)
    @scene.addObject(new THREE.AmbientLight(0x888888))
    
    # Renderer
    @renderer = new THREE.CanvasRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    document.body.appendChild(@renderer.domElement)
    
    # Stats
    @stats = new Stats()
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.left = '5px'
    @stats.domElement.style.top  = '5px'
    document.body.appendChild(@stats.domElement)
    
    # Setup input
    @bindMouseEvents()
    
    # Create the game level
    @artifact = new Artifact.Test1(@scene)
    
    # Go!
    @animate()
    
  # Bind mouse events
  bindMouseEvents: ->
    document.onmousemove = (event) =>
      @camera.move(event) if @cameraOrbiting
    
    document.onmousedown = (event) =>
      if (hits = @camera.castMouse(@scene, event)).length > 0
        hits[0].object?.onTouch?()
    
      else
        @cameraOrbiting = on
        @camera.last.x = event.clientX
        @camera.last.y = event.clientY
    
    document.onmouseup = =>
      @cameraOrbiting = off      
      
  # Animation callback
  animate: ->
    requestAnimationFrame(@animate)
    @render()
  
  # Render this frame
  render: ->
    @camera.updateOrbit()
    @renderer.render(@scene, @camera)
    @stats.update()

# Bind all methods in context of the singleton Game object
for method, func of Game
  Game[method] = _.bind(func, Game)
  

# Export Globals
window.Game = Game
  