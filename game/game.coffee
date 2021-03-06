Game =
  init: ->
    # Timing all in (ms)
    @startedAt          = @now()
    @lastFrameAt        = @now()
    @deltaTime          = 0
    @elapsedTime        = 0
    
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
    # @renderer = new THREE.WebGLRenderer()
    @renderer = new THREE.CanvasRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    document.body.appendChild(@renderer.domElement)
    
    # Animators array
    @animators = []
    
    # Stats
    @stats = new Stats()
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.left = '5px'
    @stats.domElement.style.top  = '5px'
    document.body.appendChild(@stats.domElement)
    
    # Setup input
    @bindMouseEvents()
    
    # Setup level progressions
    @artifacts = [
      Artifact.Test1
      Artifact.Test2
    ]
    
    # Create the game level
    @next()
    
    # Go!
    @animate()
    
  # Bind mouse events
  bindMouseEvents: ->
    document.onmousemove = (event) =>
      
      # Camera movement
      @camera.move event if @cameraOrbiting
      
      # Object dragging
      if @draggedObj?.onDrag?
        currentDragPosition = @camera.screenToWorldPosition event.clientX, event.clientY
        @draggedObj.onDrag currentDragPosition.clone().subSelf(@lastDragPosition)
        @lastDragPosition = currentDragPosition
    
    document.onmousedown = (event) =>
      if (hits = @camera.castMouse(@scene, event)).length > 0
        if (obj = hits[0].object)
          
          # Touch the object
          obj.onTouch?()
          
          # Start Draggin the object
          if obj.onDrag
            @lastDragPosition = @camera.screenToWorldPosition event.clientX, event.clientY
            @draggedObj = obj
      
      # Drag camera around
      else
        @cameraOrbiting = on
        @camera.last.x = event.clientX
        @camera.last.y = event.clientY
    
    # Cancel orbiting and objectdragging
    document.onmouseup = =>
      @cameraOrbiting = off
      @draggedObj = null
  
  next: ->
    if @artifact
      nextIndex = _.indexOf(@artifacts, @artifact.constructor) + 1
      nextIndex = 0 if nextIndex >= @artifacts.length      
      @scene.removeChildRecurse(@artifact)
      
    else
      nextIndex = 0
    
    @artifact = new @artifacts[nextIndex](@scene)
    @scene.addObject(@artifact)
    @artifact.birthAnimation()
    
  
  # Return the timestamp for now, in seconds.
  now: -> new Date().getTime() / 1000
  
  # Animation callback
  animate: ->
    requestAnimationFrame(@animate)
    @render()
  
  # Render this frame
  render: ->
    
    # Update camera
    @camera.updateOrbit()
    
    # Animators
    @animators = _.reject @animators, (animator) ->
      animator.update()
      animator.expired
    
    
    # Render Scene
    @renderer.render(@scene, @camera)
    
    # Update timings
    now = @now()
    @deltaTime   = now - @lastFrameAt
    @elapsedTime = now - @startedAt
    @lastFrameAt = now
    
    # Update stats
    @stats.update()

# Bind all methods in context of the singleton Game object
for method, func of Game
  Game[method] = _.bind(func, Game)
  

# Export Globals
window.Game = Game
  