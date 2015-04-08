 function [ finalMsg ] = goshapes ( vpNummer , outputFileStr , buttonBoxON, debugEnabled )

if nargin <4
  if ~exist('vpNummer'      , 'var') ;  vpNummer      = []; endif
  if ~exist('outputFileStr' , 'var') ;  outputFileStr = []; endif
  if ~exist('buttonBoxON'   , 'var') ;  buttonBoxON   = []; endif
  if ~exist('debugEnabled'  , 'var') ;  debugEnabled  = []; endif
endif

 if isempty(vpNummer)      ;  vpNummer      = 001    ; endif
 if isempty(outputFileStr) ;  outputFileStr = 'xkcd' ; endif
 if isempty(buttonBoxON)   ;  buttonBoxON   = true   ; endif
 if isempty(debugEnabled)  ;  debugEnabled  = true   ; endif


## [ finalMsg ] = goShapes ( vpNummer , outputFileStr , buttonBoxON, debugEnabled )
#  ----------------------------------------------------------------------------
#  Input:
#
#    vpNummer      = 001 (default)
#        Number of the participant. IMPORTANT this must be a number, because the
#        random seed is generated with this variable.
#
#    outputFileStr = 'xkcd' (default)
#        String variable that is added to the output file name
#        e.g. [experimentName 001 outputFileStr]
#
#    buttonBoxON   = true (default)
#        false == use the keyboard to get the rating input
#        true  == use a button-box
#        there will be a check if the box is running otherwise back to keyboard
#
#    debugEnabled  = false (default)
#        false == all error messages are suppressed
#        true  == error messages are popping up and the paths for the output is
#                 changed to hold the time stamp for maximum output ;)
#
#  ----------------------------------------------------------------------------
#  Output:
#
#    finalMsg = custom message with no purpose but it will be nice.   I promise!
#
# ----------------------------------------------------------------------------
#  Functionality
#
#
#  ----------------------------------------------------------------------------
#  Requirements
#    Psychtoolbox-3  https://psychtoolbox-3.github.io/overview/
#    awesomeStuff    https://github.com/wuschLOR/awesomeStuff
#
#  ----------------------------------------------------------------------------
#  History
#  2014-11-25 mg  changed the workspace saving routine from default ascii to 
#                 -binary to solve the loading problems with structures
#  2014-11-23 mg  written
#  ----------------------------------------------------------------------------
#  TODO
#  [ ] add check if awesomeStuff is poperly installed 
#
################################################################################


################################################################################
##  openGL
#  This script calls Psychtoolbox commands available only in OpenGL-based
#  versions of the Psychtoolbox. The Psychtoolbox command AssertPsychOpenGL will
#  issue an error message if someone tries to execute this script on a computer
#  without an OpenGL Psychtoolbox
   AssertOpenGL;
   
################################################################################   
## disable  -- less -- (f)orward, (b)ack, (q)uit 
# http://octave.1599824.n4.nabble.com/Ending-a-script-without-restarting-Octave-td4661395.html
  more off

################################################################################   
## long format output 
  format long
  
################################################################################
## change error levels of the PTB

  switch debugEnabled
    case false

      #  http://psychtoolbox.org/faqwarningprefs
      newEnableFlag = 1;
      oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', newEnableFlag);
      #  enableFlag can be:
      #  0  normal settingsnewEnableFlag
      #  1  suppresses the printout of warnings

      newLevelVerbosity = 1
      oldLevelVerbosity = Screen('Preference', 'Verbosity', newLevelVerbosity);
      #  newLevelVerbosity can be any of:
      #  ~0) Disable all output - Same as using the 'SuppressAllWarnings' flag.
      #  ~1) Only output critical errors.
      #  ~2) Output warnings as well.
      #  ~3) Output startup information and a bit of additional information. This is the default.
      #  ~4) Be pretty verbose about information and hints to optimize your code and system.
      #  ~5) Levels 5 and higher enable very verbose debugging output, mostly useful for debugging PTB itself, not generally useful for end-users.
      vpNummerStr= num2str(vpNummer);
      versionptb=Screen('Version') ## das als txt irgendwo ausgeben

    case true

      newEnableFlag = 0;
      oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', newEnableFlag);

      newLevelVerbosity = 4
      oldLevelVerbosity = Screen('Preference', 'Verbosity', newLevelVerbosity);
      versionptb=Screen('Version') ## das als txt irgendwo ausgeben

      vpNummerStr = num2str( strftime( '%Y%m%d%H%M%S' ,localtime (time () ) ) );

  endswitch

  
## Folders 
  folder.in  = [ 'input'  filesep ]
  folder.out = [ 'output' filesep]
  
## Generating the outputpaths
  resultsFolder    = ['.' filesep folder.out  'rawdata' filesep]
  resultsFolderStr = [resultsFolder vpNummerStr '_' outputFileStr]

  fileNameDiary           = [resultsFolderStr '_diary.mat']
  fileNameBackupWorkspace = [resultsFolderStr '_backupWS.mat']
  fileNameOutput          = [resultsFolderStr '_output.csv']

  diary (fileNameDiary)


  nextSeed = vpNummer # nextSeed wird für für alle random funktionen benutzt

## startup and end screens
  startImg = ['.' filesep folder.in 'startup' filesep 'startscreen.png']
  endImg   = ['.' filesep folder.in 'startup' filesep 'endscreen.png'  ]

################################################################################
##  disable random input to the console

#    ListenChar(2)

#  Keys pressed by the subject often show up in the Matlab command window as
#  well, cluttering that window with useless character junk. You can prevent
#  this from happening by disabling keyboard input to Matlab: Add a
#  ListenChar(2); command at the beginning of your script and a
#  ListenChar(0); to the end of your script to enable/disable transmission of
#  keypresses to Matlab. If your script should abort and your keyboard is
#  dead, press CTRL+C to reenable keyboard input -- It is the same as
#  ListenChar(0). See 'help ListenChar' for more info.


################################################################################
## Tasten festlegen 
# glaub das kann raus

  KbName('UnifyKeyNames'); #keine ahnung warum oder was das macht aber

  keyEscape  = KbName('escape');
  keyConfirm = KbName ('Return');

################################################################################
##  init screen

  screenNumbers=Screen('Screens');
  screenID = max(screenNumbers); # benutzt den Bildschirm mit der höchsten ID
#  screenID = 1; #benutzt den Bildschirm 1 bei Bedarf ändern

#  öffnet den Screen
#  windowPtr = spezifikation des Screens die später zum ansteueren verwendet wird
#  rect.root hat wenn es ohne attribute initiert wird die größe des Bildschirms
#  also: von 0,0 oben links zu 1600, 900 unten rechts

# Auflösungen:
#  Vanilla
#  [windowPtr,rect.root] = Screen('OpenWindow', screenID );

#  Normal sreens
#   [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [0 0 1279  800]);  #  16:10 wu Laptop
#   [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [0 0 1679 1050]);  #  16:10 wu pc
#   [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [0 0 1919 1080]);  #  16:9  testrechner

#  Windowed
#   [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [20 20 620 620]); # 1:1
#   [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [20 20 600 375]); # 16:10
#   [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [20 20 600 337]); # 16:9

  switch debugEnabled
    case false
      [windowPtr,rect.root] = Screen('OpenWindow', screenID )
    case true
      [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], [20 20 600 337]) # 16:9
  endswitch



  HideCursor(screenID)

################################################################################
##  init buttonbox

  if buttonBoxON == true
    [handle , BBworking ] = cedrusInitUSBLinux
    buttonBoxON = BBworking # change the state of buttonBoxON to true or false depending on if the initiation was successful
  endif

################################################################################
##  play around with the flip interval
# 
#   flipSlack =Screen('GetFlipInterval', windowPtr)
#   #  flipSlack =0
#   flipSlack = flipSlack/2 # das verhindert das das ganze kürzer wird hier noch etwas rumspielen - da es so manchmal zu kurze anzeigezeiten kommen kann

################################################################################
##  textstyles

  newTextFont = 'Courier New';
  newTextSize = 20;
  newTextColor= [00 00 00];

  oldTextFont  = Screen('TextFont'  , windowPtr , newTextFont );
  oldTextSize  = Screen('TextSize'  , windowPtr , newTextSize );
  oldTextColor = Screen('TextColor' , windowPtr , newTextColor);
  
  
## Pixelgröße berechnen  
display =Screen('Resolution', screenID);
[display.widthmm, display.heightmm]=Screen('DisplaySize', screenID);
display
pxmm.x=display.widthmm /display.width
pxmm.y=display.heightmm/display.height
  
################################################################################
##  settings einlesen
  rawSettingsCell = csv2cell( 'settings.csv' , ',');

  settingsHead     = rawSettingsCell(1     , :); #  zerlegten der Settings in den settingsHeader
  settingsBody     = rawSettingsCell(2:end , :); #  und dem inhaltlichen settingsBody

## konvertieren
  def = cell2struct (settingsBody, settingsHead ,2); #  konvertieren zum struct
  def = orderfields(def) #  und sortieren um ihn lesbar zu machen zu machen

  BLOCKS = length(def)

  # die hauteigenschaft fix oder nicht fixer block 
  for i=1:BLOCKS
    if strcmp(def(i).blockPosFix , 'fix')
      def(i).blockPosFix = true;
      else
      def(i).blockPosFix = false;
    endif
  endfor

################################################################################
##  Blöcke randomisieren.
  RND=0

  for i=1:BLOCKS
    if ~def(i).blockPosFix == true
      ++RND
    endif #  wie viele nichtfixe blöcke müssen randomisiert werden
  endfor
  
  rand('state' , nextSeed) # random setzen
  RNDSequence = randperm(RND);

  RND=0
  for i=1:BLOCKS
    if def(i).blockPosFix == true
      newSequence(i) = i
      ++RNDSequence
    else
      ++RND
      newSequence(i) = RNDSequence(RND)
    endif
  endfor

  for i=1:BLOCKS
    def(:,:) = def(newSequence);
  endfor

# def =
# 
#   2x1 struct array containing the fields:
# 
#     blockName
#     blockNumber
#     blockPosFix
#     crossFile
#     crossFolder
#     cueFolder
#     cueType
#     instructionFile
#     instructionFolder
#     ratingCovering
#     ratingFile
#     ratingFolder
#     stimFolder
#     stimType
#     zeitAfterpause
#     zeitBetweenpause
#     zeitCue
#     zeitFixcross
#     zeitFixcrossCue
#     zeitPrepause
#     zeitRating
#     zeitStimuli


##  Settings verarbeiten und Bildmaterial einlesen
  for BLOCKnumb=1:length(def) #  BLOCKnumb == blocknunber
    # convert times to real ms
    def(BLOCKnumb).zeitAfterpause   = def(BLOCKnumb).zeitAfterpause    /1000;
    def(BLOCKnumb).zeitBetweenpause = def(BLOCKnumb).zeitBetweenpause  /1000;
    def(BLOCKnumb).zeitFixcross     = def(BLOCKnumb).zeitFixcross      /1000;
    def(BLOCKnumb).zeitPrepause     = def(BLOCKnumb).zeitPrepause      /1000;
    def(BLOCKnumb).zeitRating       = def(BLOCKnumb).zeitRating        /1000;
    def(BLOCKnumb).zeitStimuli      = def(BLOCKnumb).zeitStimuli       /1000;
    # loding Info about pictures
    def(BLOCKnumb).stimInfo         = getFilesInFolderInfo ([folder.in def(BLOCKnumb).stimFolder       ] , def(BLOCKnumb).stimType       ); #  stimulus Info holen
    def(BLOCKnumb).cueInfo          = getFilesInFolderInfo ([folder.in def(BLOCKnumb).cueFolder        ] , def(BLOCKnumb).cueType        ); #  cue Info holen
    def(BLOCKnumb).ratingInfo       = getFileInfo          ([folder.in def(BLOCKnumb).ratingFolder     ] , def(BLOCKnumb).ratingFile     ); #  rating Infos holen
    def(BLOCKnumb).instructionInfo  = getFileInfo          ([folder.in def(BLOCKnumb).instructionFolder] , def(BLOCKnumb).instructionFile); #  instuctions info holen
    def(BLOCKnumb).crossInfo        = getFileInfo  	   ([folder.in def(BLOCKnumb).crossFolder      ] , def(BLOCKnumb).crossFile      ); #  cross info
    # make the textures
    def(BLOCKnumb).stimInfo          = makeTexFromInfo (windowPtr , def(BLOCKnumb).stimInfo       );
    def(BLOCKnumb).cueInfo           = makeTexFromInfo (windowPtr , def(BLOCKnumb).cueInfo        );
    def(BLOCKnumb).ratingInfo        = makeTexFromInfo (windowPtr , def(BLOCKnumb).ratingInfo     );
    def(BLOCKnumb).instructionInfo   = makeTexFromInfo (windowPtr , def(BLOCKnumb).instructionInfo);
    def(BLOCKnumb).crossInfo 	     = makeTexFromInfo (windowPtr , def(BLOCKnumb).crossInfo      );
        
################################################################################
# Randomisierung ALT (auskommentieren sobald nicht mehr gebraucht)
################################################################################

# version a und b generieren
#initialisiert eine Spalte von nullen die normal auf 1 gesetzt wird und in der scatter variante je nach den angegeben alternativpositionen hochaddiert bis alle einen wert von 2-5 haben die dann später durch den positonArray dekodiert werden
    STIMQA= length(def(BLOCKnumb).stimInfo); # wie viele Spalten hat stimInfo (so viele wie es stimulus im ordner gibt)
    helpNORMAL  =  zeros (STIMQA , 1)+1;
    helpSCATTER =  zeros (STIMQA , 1)+2;

    schinkenfix = floor(STIMQA/4);
    schinken = schinkenfix;
    do
      helpSCATTER(1:schinken)  = helpSCATTER(1:schinken)+1;
      schinken = schinken + schinkenfix;
    until schinken >= schinkenfix*4

    positionCol  = [helpNORMAL ; helpSCATTER];
    textureCol = [ (1:STIMQA)' ; (1:STIMQA)' ];

    hartCol = [textureCol positionCol];
    [tempCol , nextSeed ] = randomizeCol( hartCol , nextSeed , 1 );
    def(BLOCKnumb).randColTex = tempCol(:,1);
    def(BLOCKnumb).randColPos = tempCol(:,2);
    
    # neuen stimInfo generieren der die "richtige" Reihenfolge hat
    for TTT=1:length(def(BLOCKnumb).randColTex)
      def(BLOCKnumb).RstimInfo(TTT) = def(BLOCKnumb).stimInfo( def(BLOCKnumb).randColTex(TTT,:) );
    endfor
    def(BLOCKnumb).ratingVanish      = length(def(BLOCKnumb).stimInfo) / 100 * def(BLOCKnumb).ratingCovering ;
  endfor


################################################################################
## Randomisierung NEU
################################################################################
# jeder Stim muss ja 2 mal präsentiert werden für jeden cue 

    QUAcue = length(def(BLOCKnumb).cueInfo); # wie viele cues gibst
    QUAstim= length(def(BLOCKnumb).stimInfo); # wie viele stimuli sind in stimInfo
    
    # insgesammt wird es am ende cue * 2 * stimulus tails geben
    # cue * 2 da bei spatial cueing jeder stimulus sowohl rechts als auch links angezeigt wird (detection task)

    QUAcue=3
    QUAstim=5
    
    C= 1:QUAcue
    S= 1:QUAstim
    
    
    CC = C
    SS = S
    
    # cue stack
    for i= 1:QUAstim-1
      CC= [CC C]
    endfor
    
    #stim stack
    for i= 1:QUAcue-1
      SS= [SS S]
    endfor
    
    length(CC)
    length(SS)
    
    [CC', SS']
    [sort(CC'), SS']
    [CC', sort(SS')]
    

    
    
    
    
    
    
    
    
    
    
    
################################################################################
## Positionen für 16 :9 Auflösung 
################################################################################
#                3          3          3          3
#        3      ###################################   # = border / free space
#               ## ###1L## ## ###1M## ## ###1R## ##   # = actual face
#               ## ####### ## ####### ## ####### ##
#        3      ###################################
#               ## ###2L## ## ###2M## ## ###2R## ##
#               ## ####### ## ####### ## ####### ##   + = fixcross cross
#        3      ###################################
#               ## ###3L## ## ###3M## ## ###3R## ##
#               ## ####### ## ####### ## ####### ##
#        3      ###################################
#
#  die präsentationsfelder müssen alle gleich groß sein 
# x values for all locations











  
  
################################################################################
## Positionen für 16 :9 Auflösung (300 px felder für )
#
#                3          3          3          3
#        3      ###################################   # = border / free space
#               ## ###1L## ## ###1M## ## ###1R## ##   # = actual face
#               ## ####### ## ####### ## ####### ##
#        3      ###################################
#               ## ###2L## ## ###2M## ## ###2R## ##
#               ## ####### ## ####### ## ####### ##   + = fixcross cross
#        3      ###################################
#               ## ###3L## ## ###3M## ## ###3R## ##
#               ## ####### ## ####### ## ####### ##
#        3      ###################################
#
#  die präsentationsfelder müssen alle gleich groß sein 
# x values for all locations

  x.edgeLeftStart    = rect.root(1);
  x.edgeLeftEnd      = rect.root(3) / 100 *  2.34375;

      x.edgeMidLeftStart     = rect.root(3) / 100 * 17.96875;
      x.edgeMidLeftEnd       = rect.root(3) / 100 * 42.1875;

      x.edgeMidRightStart    = rect.root(3) / 100 * 57.8125;
      x.edgeMidRightEnd      = rect.root(3) / 100 * 82.03125;

  x.edgeRightStart   = rect.root(3) / 100 * 97.65625;
  x.edgeRightEnd     = rect.root(3);

  # x IMAGE LEFT
    x.imgLeftStart     = x.edgeLeftEnd      ;
    x.imgLeftEnd       = x.edgeMidLeftStart ;
      x.imgLeftCenter  = x.imgLeftStart + (x.imgLeftEnd - x.imgLeftStart)/2;

  # x IMAGE MID
    x.imgMidStart      = x.edgeMidLeftEnd    ;
    x.imgMidEnd        = x.edgeMidRightStart ;
      x.imgMidCenter   = x.imgMidStart + (x.imgMidEnd -x.imgMidStart)/2;

  # x IMAGE RIGTHT
    x.imgRightStart    = x.edgeMidRightEnd ;
    x.imgRightEnd      = x.edgeRightStart  ;
      x.imgRightCenter = x.imgRightStart + (x.imgRightEnd - x.imgRightStart)/2;

  x.center           = rect.root(3) / 2;

  # y values for all locations

  y.edgeTopStart     = rect.root(2);
  y.edgeTopEnd       = rect.root(4) / 100 *  4.1666666667;

    y.edgeMidTopStart     = rect.root(4) / 100 * 31.9444444444;
    y.edgeMidTopEnd       = rect.root(4) / 100 * 36.1111111111;

    y.edgeMidBotStart     = rect.root(4) / 100 * 63.8888888889;
    y.edgeMidBotEnd       = rect.root(4) / 100 * 68.0555555556;

  y.edgeBotStart     = rect.root(4) / 100 * 95.8333333333;
  y.edgeBotEnd       = rect.root(4);



    y.imgTopStart    = y.edgeTopEnd;
    y.imgTopEnd      = y.edgeMidTopStart;
      y.imgTopCenter   = y.imgTopStart + (y.imgTopEnd - y.imgTopStart)/2;

    y.imgMidStart    = y.edgeMidTopEnd;
    y.imgMidEnd      = y.edgeMidBotStart;
      y.imgMidCenter   = y.imgMidStart + (y.imgMidEnd - y.imgMidStart)/2;

    y.imgBotStart    = y.edgeMidBotEnd;
    y.imgBotEnd      = y.edgeBotStart;
      y.imgBotCenter   = y.imgBotStart + (y.imgBotEnd - y.imgBotStart)/2;

  y.center           = rect.root(4) / 2;

  #                 x                y            x                y
  rect.L1 = [ x.imgLeftStart  y.imgTopStart  x.imgLeftEnd  y.imgTopEnd ];
  rect.L2 = [ x.imgLeftStart  y.imgMidStart  x.imgLeftEnd  y.imgMidEnd ];
  rect.L3 = [ x.imgLeftStart  y.imgBotStart  x.imgLeftEnd  y.imgBotEnd ];
  rect.M1 = [ x.imgMidStart   y.imgTopStart  x.imgMidEnd   y.imgTopEnd ];
  rect.M2 = [ x.imgMidStart   y.imgMidStart  x.imgMidEnd   y.imgMidEnd ];
  rect.M3 = [ x.imgMidStart   y.imgBotStart  x.imgMidEnd   y.imgBotEnd ];
  rect.R1 = [ x.imgRightStart y.imgTopStart  x.imgRightEnd y.imgTopEnd ];
  rect.R2 = [ x.imgRightStart y.imgMidStart  x.imgRightEnd y.imgMidEnd ];
  rect.R3 = [ x.imgRightStart y.imgBotStart  x.imgRightEnd y.imgBotEnd ];

  positonArray(1) = {rect.M2};
  positonArray(2) = {rect.L1};
  positonArray(3) = {rect.L3};
  positonArray(4) = {rect.R1};
  positonArray(5) = {rect.R3};

  rect.instructions =  [ x.imgLeftStart  y.imgTopStart  x.imgRightEnd y.imgMidEnd ];
  rect.rating       =  [ x.imgLeftStart  y.imgBotStart  x.imgRightEnd y.imgBotEnd ];
  rect.cross        =  [ x.imgMidStart   y.imgMidStart  x.imgMidEnd   y.imgMidEnd ];

################################################################################
## render testscreens
  switch debugEnabled
    case true

     infotainment(windowPtr , 'testscreen upcomming')
        Screen('FillRect', windowPtr , [255 20 147] , rect.L1  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.L2  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.L3  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.M1  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.M2  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.M3  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.R1  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.R2  );
        Screen('FillRect', windowPtr , [255 20 147] , rect.R3  );

      Screen('Flip', windowPtr)
        KbPressWait;
      Screen('Flip', windowPtr)

      infotainment(windowPtr , 'rating testscreen')
        Screen('FillRect', windowPtr , [255 20 147] , rect.rating  );

      Screen('Flip', windowPtr)
        KbPressWait;
      Screen('Flip', windowPtr)

      infotainment(windowPtr , 'instructions testscreen')
        Screen('FillRect', windowPtr , [255 20 147] , rect.instructions  );

      Screen('Flip', windowPtr)
        KbPressWait;
      Screen('Flip', windowPtr)

  endswitch


################################################################################
## berechnen der skalierten Bilder + Lokalisation

  for j=1:BLOCKS # für alle definierten Blöcke

    m = length(def(j).RstimInfo);
    for i = 1:m # für alle vorhandenen Elemente im RstimInfo

      #  herrausfinden wie groß die textur ist - anhand des tex pointers
      texRect      = Screen('Rect' , def(j).RstimInfo(i).texture );
      # verkleinern erstellen eines recht in das die textur gemalt wird ohne sich zu verzerren
      finRect  = putRectInRect( positonArray( def(j).randColPos(i) ){}  , texRect  );
      # abspeichern
      def(j).finRect(i,1) = {finRect};
    endfor

  endfor

  for j=1:BLOCKS
    tempTex  = Screen('Rect' , def(j).ratingInfo.texture );
    finRectRating = putRectInRect (rect.rating , tempTex);
    def(j).finRectRating = {finRectRating};
  endfor

  for j=1:BLOCKS
    tempTex  = Screen('Rect' , def(j).instructionInfo.texture );
    finRectInstructions = putRectInRect (rect.instructions , tempTex);
    def(j).finRectInstructions = {finRectInstructions};
  endfor
  [empty, empty , startFLIP ] =Screen('Flip', windowPtr);

################################################################################
# MAINPART: THE MIGHTY EXPERIMENT
################################################################################

  superIndex = 0; # index über alle Durchläufe hinweg
  
  for WHATBLOCK=1:BLOCKS  # für alle definierten Blöcke
    instruTime= GetSecs+3600; # eine stunde
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).instructionInfo.texture , [] , def(WHATBLOCK).finRectInstructions{});
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).ratingInfo.texture      , [] , def(WHATBLOCK).finRectRating{}      );
      Screen('Flip', windowPtr);
      WaitSecs(10)
    for i=1:2
      Screen('DrawText'    , windowPtr , int2str(i) , 50 , 50)
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).instructionInfo.texture , [] , def(WHATBLOCK).finRectInstructions{});
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).ratingInfo.texture      , [] , def(WHATBLOCK).finRectRating{}      );
      Screen('Flip', windowPtr);
      
      switch buttonBoxON
        case false #  tastatur
          getRatingSpace (instruTime);
        case true  #  buttonbox
          cedrusGetRating (handle , instruTime);
        otherwise
          error ('critical error - this should not happen');
      endswitch
      
    endfor
    m = length(def(WHATBLOCK).RstimInfo);
    [empty, empty , timeBlockBegin ]=Screen('Flip', windowPtr);

    nextFlip = 0;

    for INBLOCK = 1:m
      ++superIndex;
      
      # PAUSE BETWEEN
      if def(WHATBLOCK).zeitBetweenpause > 0
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr);           #flip
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitBetweenpause;  # next flip
	
	  timeStamp.flipBetween = lastFLIP;
	else
	  #timeStamp.flipBetween = NA;       # auf NA setzen
	  timeStamp.flipBetween = lastFLIP;  # auf den wertdes letzten flips setzen ist sinnvoller da am ende die dauer werte berechnet werden, die sich mit dem gleichenw ert auf 0 setzen - die NA variante ist auskommentiert da die auch hübsch ist aber nicht sinnvoll
      endif
        
      # FIXCROSSCUE
      if def(WHATBLOCK).zeitFixcrossCue > 0
	  drawFixCross (windowPtr , [18 18 18] , x.center , y.center , 80 , 2 );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitFixcrossCue;
	  
	  timeStamp.flipFixCue = lastFLIP; 
        else
          #timeStamp.flipFixCue = NA; 
          timeStamp.flipFixCue = lastFLIP; 
      endif
        
      # CUE
      if def(WHATBLOCK).zeitCue > 0
	  drawFixCross (windowPtr , [18 18 18] , x.center , y.center , 80 , 2 );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitCue;
	  
	  timeStamp.flipCue = lastFLIP; 
	else
	  #timeStamp.flipCue = NA; 
	  timeStamp.flipCue = lastFLIP;
       endif
        
      
      # FIXCROSS
      if def(WHATBLOCK).zeitFixcross > 0
	  drawFixCross (windowPtr , [18 18 18] , x.center , y.center , 80 , 2 );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitFixcross;
	  
	  timeStamp.flipFix = lastFLIP;
        else
          #timeStamp.flipFix = NA;
          timeStamp.flipFix = lastFLIP;
      endif

      # PAUSE PRE
      if def(WHATBLOCK).zeitPrepause > 0
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitPrepause ;
	  
	  timeStamp.flipPre = lastFLIP;
	else
	  #timeStamp.flipPre = NA;
	  timeStamp.flipPre = lastFLIP;
      endif
      
      # STIMULUS
      if def(WHATBLOCK).zeitStimuli > 0
	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).RstimInfo(INBLOCK).texture , [] , def(WHATBLOCK).finRect(INBLOCK,1){} );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitStimuli;

	  timeStamp.flipStim = lastFLIP;
        else
	  #timeStamp.flipStim = NA;
	  timeStamp.flipStim = lastFLIP;
      endif
 
      # PAUSE AFTER
      if def(WHATBLOCK).zeitAfterpause > 0
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitAfterpause;

	  timeStamp.flipAfter = lastFLIP;
	else
	  #timeStamp.flipAfter = NA;
	  timeStamp.flipAfter = lastFLIP;
      endif
      
      # RATING
        if INBLOCK< def(WHATBLOCK).ratingVanish
          Screen( 'DrawTexture' , windowPtr , def(WHATBLOCK).ratingInfo.texture , [] , def(WHATBLOCK).finRectRating{} ,[], [], [], [255 255 255 0]);
          # hier noch mit der modulateColor rumspielen ob mann das rating nicht rausfaden lassen kann ;)
        endif

        #flip
        [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
        nextFlip = lastFLIP + def(WHATBLOCK).zeitRating;

        timeStamp.flipRating = lastFLIP;
        

      # reaktionszeit abgreifen
      switch buttonBoxON
        case false #tastatur
          [pressedButtonTime , pressedButtonValue , pressedButtonStr] = getRating7 (nextFlip);
        case true #buttonbox
          [pressedButtonTime , pressedButtonValue , pressedButtonStr] = cedrusGetRating (handle , nextFlip);
        otherwise #wtf
          error ('critical error - this should not happen');
      endswitch
      Screen('Flip', windowPtr);



      # dauer der einzelnen vorgänge berechnen
      # dauer. irgendwas        =  stamp punktdannach  - stamp punkt anfang
      dauer.betweenpause        = timeStamp.flipFixCue - timeStamp.flipBetween ;
      dauer.fixcrosscue         = timeStamp.flipCue    - timeStamp.flipFixCue  ;
      dauer.cue                 = timeStamp.flipFix    - timeStamp.flipCue     ;
      dauer.fixcross            = timeStamp.flipPre    - timeStamp.flipFix     ;
      dauer.prepause            = timeStamp.flipStim   - timeStamp.flipPre     ;
      dauer.stimulus            = timeStamp.flipAfter  - timeStamp.flipStim    ;
      dauer.afterpause          = timeStamp.flipRating - timeStamp.flipAfter   ;
      dauer.rating              = pressedButtonTime    - timeStamp.flipRating  ;
      dauer.reactionTimeStimON  = pressedButtonTime    - timeStamp.flipStim    ;
      dauer.reactionTimeStimOFF = pressedButtonTime    - timeStamp.flipAfter   ;


      #    dem outputfile werte zuweisen
      OUThead        =       { ...
        'vpNummer'           , ...
        'vpCode'             , ...
        'index'              , ...
        'blockIndex'         , ...
        'blockBeschreibung'  , ...
        'cue'		     , ...
        'cuegroesse'         , ...
        'stimulus'           , ...
        'stimgroesse'        , ...
        'keyString'          , ...
        'keyValue'           , ...
        'reactionStimON'     , ...
        'reactionStimOFF'    , ...
        'dauerBetween'       , ...
        'dauerFixCue'        , ...
        'dauerCue'           , ...
        'dauerFix'           , ...
        'dauerPre'           , ...
        'dauerStim'          , ...
        'dauerAfter'         , ...
        'dauerRating'        };

      OUTcell(superIndex,:) =                      { ...
        vpNummer                                   , ...
        outputFileStr                              , ...
        num2str(superIndex)                        , ...
        num2str(INBLOCK)                           , ...
        def(WHATBLOCK).blockName                   , ...
        'cue'                                      , ...
        'cuegroesse'                               , ...
        def(WHATBLOCK).RstimInfo(INBLOCK).name     , ...
        'stimgroesse'                              , ...
        pressedButtonStr                           , ...
        pressedButtonValue                         , ...
        dauer.reactionTimeStimON                   , ...
        dauer.reactionTimeStimOFF                  , ...
        dauer.betweenpause                         , ...
        dauer.fixcrosscue                          , ...
        dauer.cue                                  , ...
        dauer.fixcross                             , ...
        dauer.prepause                             , ...
        dauer.stimulus                             , ...
        dauer.afterpause                           , ...
        dauer.rating                               };

      # attatch names to the OUTcell
      OUTcellFin = [OUThead ; OUTcell];
      #  speicherndes output files
      cell2csv ( fileNameOutput , OUTcellFin, ',');

    endfor
  endfor

################################################################################
# MAINPART: THE MIGHTY EXPERIMENT IS OVER HOPE YOU DID GREAT
################################################################################


################################################################################
##  Data saving



  #  den workspace sichern (zur fehlersuche usw)
  save ('-binary',fileNameBackupWorkspace)

  # attatch names to the OUTcell
  OUTcellFin= [OUThead ; OUTcell]

  #  speicherndes output files
  cell2csv ( fileNameOutput , OUTcellFin, ',')


  diary off
  infotainment(windowPtr , 'saving your data')
################################################################################
##  end all processes
  infotainment(windowPtr , 'target aquired for termination')

  ListenChar(0)
  Screen('closeall')

  try
    CedrusResponseBox('CloseAll');
  end

  finalMsg = 'geschafft'

endfunction

