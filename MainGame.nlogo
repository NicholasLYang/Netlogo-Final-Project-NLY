globals [amountOfJumps levelNumber jumpDirection fallVelocity centerOfLightX centerOfLightY calcDarkness lavaDeath countJumps? outerRing]
; Limits number of jumps per level
breed [players player]
breed [ghosts ghost] 
breed [poisons poison]
breed [bullets bullet]
patches-own [poisonLife ghostLife sprungPlate]
to Start
  ca
reset-ticks
set levelNumber -1.5
set calcDarkness false
set lavaDeath false
set countJumps? false
end
to PlayerSetup
; sets up player on red "door" patch
ask patch -15 -14 [
                   
                   sprout-players 1
                   [ 
                     set color orange
                     set shape "person"
                     set heading 90
                     set size 1
                   ]
                  ]


end
;to poison 
;  ask turtles
;  [ if [pcolor] of patch-here = pink
;   [ ask turtles-here [die] ]]      
;end

 
to clear
  ca
end
to gameRules
gravityRules
Walls
Lava
helpScreenMonitors
LevelProgression
displayAmountOfJumps
pressurePlate
bulletmovement
bulletghostcollison
; poison 
noSharing
poisonSpawn
ghostSpawn
end
to noSharing
  ask players
  [ 
    if any? poisons-here
    [
      die
    ]
  ]
end


to poisonSpawn
  ask patches with [distancexy centerOfLightX centerOfLightY <= outerRing and pcolor = one-of [pink 132]] 
  
    [ ifelse poisonLife
      [
      sprout 1
      [ set breed poisons
        set shape "square"
        set color 54
        set heading 0
      ]
      ]
      []
    ]
  ask poisons 
  [ 
    if [pcolor] of patch-here = black
   [die]
  ]
  
end

to ghostSpawn
    ask patches with [distancexy centerOfLightX centerOfLightY <= 6 and pcolor = one-of [violet 123]] 
  
    [ ifelse ghostLife
      [
        sprout 1 
          [ set breed ghosts
            set shape "ghost"
            set color red
            set heading 0
          ]
        
      ]
      [ ]
    ]
  ask ghosts 
  [ 
    if [pcolor] of patch-here = black
   [die]
  ]
  
  
  
end
  

to pressurePlate
  ask turtles
  [
    if [pcolor] of patch-here = brown
    [
      if levelnumber = .5  [mock
      ask patch-here [set sprungPlate true]
      ]
      ask patch-here [set sprungPlate true]
      
    ]
  ]
 ask patches with [sprungPlate = true and distancexy centerOfLightX centerOfLightY < 6]
 [
      ask patch-at 1 0 [set pcolor white]
      ask patch-at 1 1 [set pcolor white]
      ask patch-at 1 2 [set pcolor white]
      ask patch-at 0 -1 [set pcolor orange]
      
 ]
 tick
end

to mock

      ask patch  6 1 [ set plabel "Ha ha ha. Scrub"]
      ask patch  6 0 [ set plabel "By the way, pressure"]
      ask patch  6 -1 [ set plabel "plates are brown"]
      ask patches with [pxcor >= -2 and pxcor <= 7 and pycor >= -2 and pycor <= 2] [set pcolor blue]
end

to displayAmountOfJumps
  ; displays amount of jumps left on upper left corner
  if levelNumber > 1
  [
  ask patch -15 15 [set plabel amountOfJumps]
  ]
end
  
to gravityRules
  ; If the turtle is facing to the left, it makes sure that there's a block on its left (aka downward). If there is, it stays put. 
  ; Else it moves "downward" and then orients itself back to the left
 
    ask players with [heading = 270] 
  [
   ifelse [pcolor] of patch-left-and-ahead 90 1 = white
    [
     if fallVelocity >= fallHeight 
     [
       die 
       playersetup 
       set calcdarkness true
       ] 
     set fallVelocity 0
    ]
    
    [
    lt 90
    fd 1
    rt 90 
    set fallVelocity fallVelocity + 1
    set calcDarkness true
    ]
  ] 
     ; Likewise, this does the samething except if the turtle is facing right.
  
  ; Added a gravity monitor. Basically every time that the turtle falls, one is added to the velocity (not realistic, but who cares)
  ; When the turtle "hits" the ground, the velocity is compared to the fallHeight variable. If it's larger than the fallHeight, the turtle dies
  ask turtles with [heading = 90] 
  [
   ifelse [pcolor] of patch-right-and-ahead 90 1 = white 
    [
      
      if fallVelocity >= fallHeight [die PlayerSetup set fallvelocity 0] 
       set fallVelocity 0  
       
        
    ]
    [
    rt 90
    fd 1
    lt 90
    set fallVelocity fallVelocity + 1
    set calcDarkness true
    ]
  ]
  if calcDarkness 
  [
    darkness
    set calcDarkness false
  ]
  
end
  to walls
    ; Makes sure players can't go through walls. I tried various routes, this worked the best. Though there could be flickering on the player momentarily being on the white block. 
    ; Not much I could do about that, as netlogo doesn't allow for turtles to ignore commands. 
    ask players
  [
  if [pcolor] of patch-here = white
  [
    bk 1
  ]
  ]
end
to Lava
  ; Pretty self explanatory. Lava hurts 
  ask players
  [ if [pcolor] of patch-here = orange
    [
     set lavaDeath true
    ]
  ]
  if lavaDeath
  [
   fuck
   set lavaDeath false
  ]

  tick

end
to darkness
  if levelNumber = 1.5
  [
    import-pcolors "level1.png"
    ask players 
    [
      set centerOfLightX xcor
      set centerofLightY ycor
ask patches with [distancexy centerOfLightX centerOfLightY >= outerRing] [set pcolor black]
    ask patches with [distancexy centerOfLightX centerOfLightY > outerRing - 1 and distancexy centerOfLightX centerOfLightY < outerRing] [set pcolor pcolor - 3]

    ]
  ]
  if levelNumber = 2.5
  [
    import-pcolors "level2.png"
    ask players
    [
      set centerOfLightX xcor
      set centerofLightY ycor
    ask patches with [distancexy centerOfLightX centerOfLightY >= outerRing] [set pcolor black]
    ask patches with [distancexy centerOfLightX centerOfLightY > outerRing - 2 and distancexy centerOfLightX centerOfLightY < outerRing] [set pcolor pcolor - 3]
    
    ]
  ]
  if levelnumber = 3.5
  [
    import-pcolors "level3.png"
    ask players
    [
      set centerOfLightX xcor
      set centerofLightY ycor
    ask patches with [distancexy centerOfLightX centerOfLightY >= outerRing] [set pcolor black]
    ask patches with [distancexy centerOfLightX centerOfLightY > outerRing - 2 and distancexy centerOfLightX centerOfLightY < outerRing] [set pcolor pcolor - 3]
    
    ]
  ]
  if levelnumber = 4.5
  [
    import-pcolors "level4.png"
    ask players
    [
      set centerOfLightX xcor
      set centerofLightY ycor
    ask patches with [distancexy centerOfLightX centerOfLightY >= outerRing] [set pcolor black]
    ask patches with [distancexy centerOfLightX centerOfLightY > outerRing - 2 and distancexy centerOfLightX centerOfLightY < outerRing] [set pcolor pcolor - 3]
    
    ]
  ]
    if levelnumber = 5.5
  [
    import-pcolors "level5.png"
    ask players
    [
      set centerOfLightX xcor
      set centerofLightY ycor
    ask patches with [distancexy centerOfLightX centerOfLightY >= outerRing] [set pcolor black]
    ask patches with [distancexy centerOfLightX centerOfLightY > outerRing - 2 and distancexy centerOfLightX centerOfLightY < outerRing] [set pcolor pcolor - 3]
    
    ]
  ]
    
end
to helpScreenMonitors
  ; Every time a player reaches a certain patch, a help monitor turns on. 
  if levelNumber = -1
  [ask patch -7 -9 [ set plabel "Press D to Move Right"]]
  if levelNumber = 0 
  [ 
    if any? turtles-on patch 2 -15
  [ ask patch 14 -15 [ set plabel "Press E to Jump Right"] ]
    if any? turtles-on patch 15 -10
  [ask patch 13 -6 [ set plabel "Press Q to Jump Left"  ]
   ask patch 13 0 [ set plabel "Hold mouse to double jump"]]
    if any? turtles-on patch 13 -9
   [ask patch 0 -2 [ set plabel "Press A to Move Left" ] ]
    
  
  ]
  if levelnumber = .5
  [
    if any? turtles-on patch -5 -12
    [ ask patch 2 -8 [ set plabel "Lava hurts. Don't get burned!"]]
    if any? turtles-on patch 8 7
    [  
        ask patch 11 10 [ set plabel "do a super duper jump" ]
        ask patch 11 11 [ set plabel "on a yellow patch, you'll"] 
        ask patch 11 12 [ set plabel "If you hold down your mouse"]
    ]
    
  ]
  if levelnumber = 1.5
  [
    if any? turtles-on patch -15 -14 
    [ ask patch -12 -11 [set plabel "Uh oh"]]
    if any? turtles-on patch -8 -14
    [ 
      ask patches [set plabel ""]
      ask patch -5 -11 [set plabel "the lights went out"]
      ]
        if any? turtles-on patch -6 -14
    [ 
      ask patches [set plabel ""]
      ask patch -5 -11 [set plabel "can you"]
      ]
        if any? turtles-on patch -3 -12
    [ 
      ask patches [set plabel ""]
      ask patch -1 -9 [set plabel "find the switch?"]
      ]
        if any? turtles-on patch -1 -10
    [ 
      ask patches [set plabel ""]
      ask patch 4 -7 [set plabel "Good luck!"]
      ]
    if any? turtles-on patch 6 -9 
    [ 
      ask patches [set plabel ""]
    ]

    
  ]
  if levelnumber = 3.5 
  [
    if any? turtles-on patch -12 -12
    [
      ask patch -8 -11 [set plabel "Hey, green squares"]
    ]
    if any? turtles-on patch -9 -12
    [
      ask patches [set plabel ""]
      ask patch -5 -12 [set plabel "they must be poisonous"]
    ]
    if any? turtles-on patch -8 -14
    [
      ask patches [set plabel ""]
      ask patch -4 -12 [set plabel "better use your gun"]
      ask patch -4 -13 [set plabel "to kill them"]
    ]
    if any? turtles-on patch -7 -14
    [
      ask patches [set plabel ""]
    ]
    if any? turtles-on patch -5 -14
    [
      ask patch -3 -12 [set plabel "Press space to shoot"]
      ask patch -3 -11 [set plabel "Hold mouse to aim"]
    ]
    if any? turtles-on patch -4 -14
    [
      ask patches [set plabel ""]
    ]
  ]
end
to LevelProgression
  ; Allows for progression through levels by changing the global variable levelNumber. Basically every time the player touches a red door, it raises the level number by half a point. 
  ; This "warps" the player into the next level. However, it also sets the level number to a constant number, so that it doesn't continue to raise the level number as the player is standing on the door. 
  ; If this doesn't make sense, I can explain more. 
  ask players
  [
    if [pcolor] of patch-here = green
    [
      
      set levelNumber levelNumber + .5
      die
    ]
   if any? turtles-on patch 16 3 
      [
        set levelNumber .1
        ask players [die]
      ]
  ]
      if levelNumber = -1.5
  [
    ask players [die]
    import-pcolors "TitleScreen.png"
    PlayerSetup
    set levelNumber -1
    set countJumps? false
  ]
    if levelNumber = -.5
    [
      ; Help Screen. 
      ask patches [set plabel ""]
      ask players [die]
      import-pcolors "HelpScreen.png"
      set countJumps? false
      PlayerSetup
      set levelNumber 0

     
      
    ]
    
    if levelNumber = .1
     ; Second part of the help screen. Once you go to the end of the window, it loads the next part
    [
      set levelNumber .5
       
       ask patches [set plabel ""]
      import-pcolors "HelpScreen2.png"
        ask patch -6 14 [ set plabel "Often there's more than" ]
        ask patch -6 13 [ set plabel "one way to get to the" ]
        ask patch -6 12 [ set plabel "end. Choose wisely" ]
        ; Had to setup players manually because this isn't a new level per se
        ask patch -15 -14 [ sprout-players 1
                   [ 
                     set color orange
                     set shape "person"
                     set heading 90
                     set size 1
                   ]
        ]
      ]
    
    
  if levelNumber = 1
  [
    ; Level 1, designed by Nicholas Yang
    level1setup
  ]
  if levelNumber = 2
  [
    ; Level 2, designed by Mohammed Shium
    level2setup
  ]
  if levelNumber = 3
  [ ;level 3 designed by Mohammed Shium
    level3setup]
  if levelNumber = 4
  [ ;level 4 designed by Kevin Yan and Mohammed Shium
    level4setup] 
  if levelNumber = 5
  [ ;level 5 designed by Kevin Yan 
    level5setup] 
  

end
to moveLeft
  ask players
  [  
    ; I decided against just making it so the player faces one and only one direction because it made jumping and potentially velocity a pain in the ass. 
    ; Also makes walls easier to deal with
    set heading 270
    ifelse [pcolor] of patch-ahead 1 = white
    [
      set heading 90
    ]
    [
    fd 1
    set heading 90
    
    ]
  ]
  darkness
end

to moveRight

 
  ask players
  [
    set heading 90
    ifelse [pcolor] of patch-ahead 1 = white
    [
    ]
    [
      fd 1
    ]
  ]
  darkness

end

;to blocks 
;  ask patches with [pxcor > -5 and pxcor < 5 and pycor >= -15 and pycor <= -14 ] [set pcolor white] 
;ask patches with [pxcor > -4 and pxcor < 5 and pycor >= -15 and pycor <= -13 ] [set pcolor white]
;ask patches with [pxcor > -3 and pxcor < 5 and pycor >= -15 and pycor <= -12 ] [set pcolor white]
;ask patches with [pxcor > -2 and pxcor < 5 and pycor >= -15 and pycor <= -11 ] [set pcolor white]
;ask patches with [pxcor = 6 and pycor < -9] [set pcolor white] 
;ask patches with [pxcor = 8 and pycor < -8] [set pcolor white]
;ask patches with [pxcor = 10 and pycor < -7] [set pcolor white]
;ask patches with [pxcor > 11 and pycor =  -7] [set pcolor white]
;ask patches with [pxcor < 11 and pycor =  -5] [set pcolor white]
;end

to jumpright

  ; Jumping right. Very basic, need to use ticks to make it more smooth. 
  ; If you hold down your mouse, you do a super jump (2 up and 2 across). Way easier than velocity.
  ; If you're on a yellow patch and holding down your mouse, you do a super duper jump (3 up and 3 across).
  ; This doesn't work, because for some reason netlogo doesn't calculate sqrt 2 properly. Will fix soon
  ; Basically need to make it so the turtle, if it hits a wall, rebounds instead of just falling directly down
  ; Also, amountOfJumps depends on the length of the jump. 
  ; I.e. a super jump takes two off of the counter, a normal jump takes one off of the counter, etc
  ; Ugh, so getting amount of jumps working is not easy. I basically doubled the amount of code. Will simplify when I have the time
      ifelse countJumps? 
  [
    ifelse amountOfJumps = 0 []
    [  
      jumpRightMovement
      darkness
    ]
  ]
  [
    jumpRightMovement
    darkness
  ]
 end
 to jumpRightMovement
  ask players
  [
 ifelse [pcolor] of patch-here = yellow
  [
    ifelse mouse-down?
    [ 
      if amountOfJumps < 3 [ ]
      set amountOfJumps amountOfJumps - 3
      set heading 45
      if [pcolor] of patch-ahead 0 = white []   
      set ycor ycor + 1
      set xcor xcor + 1

      if [pcolor] of patch-ahead 0 = white
       [
        set ycor ycor - 1
        set xcor xcor + 1
        set heading 90
       ]
      set ycor ycor + 1
      set xcor xcor + 1
      if [pcolor] of patch-ahead 0 = white
       [
        set ycor ycor - 1
        set xcor xcor + 1
        set heading 90
       ]
      set ycor ycor - 1
      set xcor xcor + 1
    
      set heading 90
      
    ]
    [
      if amountOfJumps < 2 []
        set amountOfJumps amountOfJumps - 2
        set heading 45
        if [pcolor] of patch-ahead 0 = white []
        set ycor ycor + 1
        set xcor xcor + 1
        if [pcolor] of patch-ahead 0 = white
        [
          set ycor ycor - 1
          set xcor xcor + 1
          set heading 90]
        set ycor ycor + 1
        set xcor xcor + 1
        set heading 90
    ]
  ]
  [
  ifelse mouse-down?
  [
    if amountOfJumps < 2 []
      set amountOfJumps amountOfJumps - 2
      set heading 45
        if [pcolor] of patch-ahead 0 = white []
        set ycor ycor + 1
        set xcor xcor + 1
        if [pcolor] of patch-ahead 0 = white
        [
          set ycor ycor - 1
          set xcor xcor + 1
          set heading 90
        ]
        set ycor ycor + 1
        set xcor xcor + 1
        set heading 90

    
    
  ]
  [
  set heading 45
  if [pcolor] of patch-ahead 0 = white []
  set ycor ycor + 1
  set xcor xcor + 1
  set heading 90
  set amountOfJumps amountOfJumps - 1
  ]
  ]

  
  ; Every time that the player moves, darkness is calculated
  
 ]
  
end


to jumpLeft
 ifelse countJumps? 
  [
    ifelse amountOfJumps = 0 []
    [
        jumpLeftMovement
        darkness
    ]
  ]
  [
    jumpLeftMovement
    darkness
  ]
end
to level1Setup
    ask players [die]
    set outerRing 6
    ask patches [ set plabel ""]
    import-pcolors "Level1.png"
    PlayerSetup
    set levelNumber 1.5
    set countJumps? true
    darkness
    ifelse difficultyLevel = "Easy"
      [
        set amountOfJumps 27
      ]
      [        
        ifelse difficultyLevel = "Medium"
        [
          set amountOfJumps 25
        ]
        [set amountOfJumps 23]
      ]
      displayAmountOfJumps

end
to level2setup
      ask players [die]
    import-pcolors "Level2final.png"
    PlayerSetup
    set levelNumber 2.5
    set outerRing 7
    set countJumps? true
    darkness
        ifelse difficultyLevel = "Easy"
      [
        set amountOfJumps 110
      ]
      [        
        ifelse difficultyLevel = "Medium"
        [
          set amountOfJumps 106
        ]
        [set amountOfJumps 102]
      ]
  
end
to level3setup
  ; Level 3, designed by Mohammed Shium
    ask players [die]
    set outerRing 8
    import-pcolors "Level3.png"
    PlayerSetup
    set amountOfJumps 200
    set levelNumber 3.5
    ask patches 
    [
      set poisonlife true
      set ghostLife true
      ]
 
end
to level4setup
  ;level 4 designed by Kevin Yan and Mohammed Shium
   ask players [die]
   set outerRing 9
   ask ghosts [die]
    import-pcolors "Level4.png"
    ask patches [set sprungPlate false]
     playersetup
     set levelNumber 4.5
end
to level5setup
  ;level 5 designed by Kevin Yan 
  ask patches [set plabel ""]
  set outerRing 10
   ask players [die]
   ask ghosts [die]
   ask patches [set sprungPlate false]
    import-pcolors "Level5.png"
   
     playersetup
     set levelNumber 5.5
       ifelse difficultyLevel = "Easy"
      [
        set amountOfJumps 114
      ]
      [        
        ifelse difficultyLevel = "Medium"
        [
          set amountOfJumps 110
        ]
        [set amountOfJumps 105]
      ]
  
end

to jumpLeftMovement
      ask players
        [
          ifelse [pcolor] of patch-here = yellow
           [
            ifelse mouse-down?
             [  
               set amountOfJumps amountOfJumps - 3
               set heading 315
               if [pcolor] of patch-ahead 0 = white []  
               set ycor ycor + 1 
               set xcor xcor - 1
               if [pcolor] of patch-ahead 0 = white
                [
                 set ycor ycor - 1
                 set xcor xcor - 1
                 set heading 270
                ]
              set ycor ycor + 1
              set xcor xcor - 1
              if [pcolor] of patch-ahead 0 = white
              [
                set ycor ycor - 2
                set xcor xcor - 2
                set heading 270]
              set ycor ycor + 1
              set xcor xcor - 1
              set heading 270
      
             ]
             [
               set amountOfJumps amountOfJumps - 2
               set heading 315
               if [pcolor] of patch-ahead 0 = white []
               set ycor ycor + 1
               set xcor xcor - 1
               if [pcolor] of patch-ahead 0 = white
               [
                 set ycor ycor - 1
                 set xcor xcor - 1
                 set heading 270
          ]
               set ycor ycor + 1
               set xcor xcor - 1
       
               set heading 270
             ]
           ]
           [
             ifelse mouse-down?
             [
               set amountOfJumps amountOfJumps - 2
               set heading 315
               if [pcolor] of patch-ahead 0 = white []
               set ycor ycor + 1
               set xcor xcor - 1
       
               if [pcolor] of patch-ahead 0 = white
               [
                 set ycor ycor - 1
                 set xcor xcor - 1
                 set heading 270]
               set ycor ycor + 1
               set xcor xcor - 1  
     
               set heading 270
    
    
             ]
             [
               set amountOfJumps amountOfJumps - 1
               set heading 315
               if [pcolor] of patch-ahead 0 = white []
               set ycor ycor + 1
               set xcor xcor - 1
               set heading 270

             ]
           ]
        ]


      
   

end



to fuck
  ask turtles [die]
  set fallVelocity 0
  
  ; Fuck, you're dead. Now go get reincarnated you incompetent fucker. Seriously gotta remove these comments before Platek sees this code
set levelnumber levelnumber - .5
playersetup
darkness
  end
; Just to create/sketch out levels

to paintTurquoise 
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor 83]]
end
to paintBlue
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor blue]]
end

to paintWhite
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor white]]
end

to paintOrange
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor orange]]
end

to paintGreen
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor green]]
end
to paintBlack
  if mouse-down?
[ask patch mouse-xcor mouse-ycor [set pcolor black]]
end

to paintRed
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor red]]
end
to paintYellow
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor yellow]]
end
to paintViolet
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor violet]]
end
to paintBrown
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor brown]]
end
to paintPink
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor pink]]
end
to paintGrey
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor grey]]
end
to paintDarkYellow
  if mouse-down?
  [ask patch mouse-xcor mouse-ycor [set pcolor 43]]
end
to setlevel2
  set levelNumber 2
end
to setlevel3
  set levelnumber 3
end
to setlevel4
  set levelnumber 4
end
to setlevel5
  set levelnumber 5
end

to shoot 
  if mouse-down? 
  [ask players [facexy mouse-xcor mouse-ycor]]
    ask players
    [hatch-bullets 1 [
                       set shape "rocket"
                         set color green
                       set size  1 ;0.75
                       
                       fd 1
                     ] ]
end
to bulletmovement 
  ask bullets [fd  1]
  tick
end     
to bulletghostcollison
  tick
  ask patches with [any? bullets-here and pcolor = white] [ask bullets-here [die]]
  ask patches with [any? bullets-here and pcolor = orange][ask bullets-here [die]]
  ask patches with [any? bullets-here and pcolor = green][ask bullets-here [die]]
  ask patches with [any? bullets-here and pcolor = yellow][ask bullets-here [die]]
  ask patches with [any? bullets-here and pcolor = pink and any? poisons-here] 
  [
    set poisonLife false 
    ask bullets-here [die]
    ask poisons-here [die]
    ]
  ask patches with [any? bullets-here and pcolor = violet and any? ghosts-here] 
  [
    set ghostLife false  
    ask bullets-here [die]
    ask ghosts-here [die]
  ]
  ask ghosts with [any? bullets-here ][ask bullets-here [die] ask ghosts-here [die]]
  ask ghosts with [any? players-here ][ask players-here [die] playersetup]
  ask bullets with [pxcor = max-pxcor] [ask bullets-here [die]]
  ask bullets with [pxcor = min-pxcor] [ask bullets-here [die]]
  ask bullets with [pycor = max-pycor] [ask bullets-here [die]]
  ask bullets with [pycor = min-pycor] [ask bullets-here [die]]
  ask poisons with [any? bullets-here ][ask bullets-here [die] ask poisons-here [die]]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
649
470
16
16
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
81
181
168
214
NIL
moveright
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
89
138
152
171
NIL
clear
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
4
181
84
214
NIL
moveleft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
89
300
172
333
NIL
jumpright
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

BUTTON
82
394
180
427
NIL
gameRules
T
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
56
339
138
372
NIL
jumpleft
NIL
1
T
OBSERVER
NIL
Q
NIL
NIL
1

BUTTON
78
50
141
83
NIL
fuck
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
832
52
928
85
NIL
paintWhite
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
831
14
919
47
NIL
paintBlue
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
830
240
939
273
NIL
paintOrange
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
832
160
932
193
NIL
paintGreen
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
831
88
925
121
NIL
paintBlack
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
832
125
918
158
NIL
paintRed
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
722
229
785
262
NIL
start
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
742
353
832
398
NIL
levelNumber
17
1
11

BUTTON
830
200
932
233
NIL
paintYellow
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
832
282
929
315
NIL
paintViolet
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
24
103
196
136
fallHeight
fallHeight
0
10
10
1
1
NIL
HORIZONTAL

MONITOR
120
253
200
298
NIL
fallVelocity
17
1
11

BUTTON
729
97
817
130
NIL
darkness
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
709
421
847
466
DifficultyLevel
DifficultyLevel
"Easy" "Medium" "Hard"
0

BUTTON
82
451
214
484
NIL
set fallVelocity 0
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
940
51
1041
84
NIL
paintBrown
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
711
173
808
206
NIL
playersetup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
718
37
799
70
NIL
paintpink
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
683
299
806
332
NIL
ask players [die]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
891
424
1010
457
NIL
ask ghosts [die]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
60
239
123
272
NIL
shoot
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
934
10
1022
43
NIL
paintPink
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
938
94
1064
127
NIL
paintTurquoise\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
863
344
937
377
reload
set levelnumber levelnumber - .5
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
961
209
1065
242
Clear plabel
ask patches [set plabel \"\"]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
957
318
1049
351
NIL
paintGrey
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
991
375
1122
408
NIL
paintDarkYellow
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

ghost
false
0
Polygon -7500403 true true 30 165 13 164 -2 149 0 135 -2 119 0 105 15 75 30 75 58 104 43 119 43 134 58 134 73 134 88 104 73 44 78 14 103 -1 193 -1 223 29 208 89 208 119 238 134 253 119 240 105 238 89 240 75 255 60 270 60 283 74 300 90 298 104 298 119 300 135 285 135 285 150 268 164 238 179 208 164 208 194 238 209 253 224 268 239 268 269 238 299 178 299 148 284 103 269 58 284 43 299 58 269 103 254 148 254 193 254 163 239 118 209 88 179 73 179 58 164
Line -16777216 false 189 253 215 253
Circle -16777216 true false 102 30 30
Polygon -16777216 true false 165 105 135 105 120 120 105 105 135 75 165 75 195 105 180 120
Circle -16777216 true false 160 30 30

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rocket
true
0
Polygon -7500403 true true 120 165 75 285 135 255 165 255 225 285 180 165
Polygon -1 true false 135 285 105 135 105 105 120 45 135 15 150 0 165 15 180 45 195 105 195 135 165 285
Rectangle -7500403 true true 147 176 153 288
Polygon -7500403 true true 120 45 180 45 165 15 150 0 135 15
Line -7500403 true 105 105 135 120
Line -7500403 true 135 120 165 120
Line -7500403 true 165 120 195 105
Line -7500403 true 105 135 135 150
Line -7500403 true 135 150 165 150
Line -7500403 true 165 150 195 135

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
