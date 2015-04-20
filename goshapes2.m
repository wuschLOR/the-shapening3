#  function [ finalMsg ] = goshapes2 ( vpNummer , outputFileStr , buttonBoxON , debugEnabled , screendist )

## [ finalMsg ] = goShapes2 ( vpNummer , outputFileStr , buttonBoxON, debugEnabled , screendist )
################################################################################
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
#    screendist  = 80 cm
# 	 distance participant Screen in cm. Used for processing the degrees of 
#        eccentricity
#
################################################################################
#  Output:
#
#    finalMsg = custom message with no purpose but it will be nice.   I promise!
#
################################################################################
#  Requirements
#    Psychtoolbox-3  https://psychtoolbox-3.github.io/overview/
#    awesomeStuff    https://github.com/wuschLOR/awesomeStuff
#
################################################################################
#  History
#  2015-04-XX mg  written
#
################################################################################

################################################################################
## defaults


  # wenn weniger als 5 agrumente gegeben wurden als die funktion gestartet ist dann mal alles was nicht initialisiert wurde zumindest nenn empty value geben
  if nargin <5
    if ~exist('vpNummer'      , 'var') ;  vpNummer      = []; endif
    if ~exist('outputFileStr' , 'var') ;  outputFileStr = []; endif
    if ~exist('buttonBoxON'   , 'var') ;  buttonBoxON   = []; endif
    if ~exist('debugEnabled'  , 'var') ;  debugEnabled  = []; endif
    if ~exist('screendist'    , 'var') ;  screendist    = []; endif
  endif

  # default array
  default.vpNummer      = 001   ;
  default.outputFileStr ='xkcd' ;
  default.buttonBoxON   = true  ;
  default.debugEnabled  = true  ;
  default.screendist    = 80    ;
  
  # old check and set default
#   if isempty(vpNummer)      ;  default.vpNummer      ; endif
#   if isempty(outputFileStr) ;  default.outputFileStr ; endif
#   if isempty(buttonBoxON)   ;  default.buttonBoxON   ; endif
#   if isempty(debugEnabled)  ;  default.debugEnabled  ; endif
#   if isempty(screendist)    ;  default.screendist    ; endif

  
  #new check and set default 
  
  # alles was numbers sein sollen
  if isempty(vpNummer) # is es leer (weil beim start nix angegeben wurde?)
    valid = false;
    do
      inputtext     = 'VP Nummer default 001 (ENTER). Otherwise type number: ';
      inputargument = input (inputtext , 's'); # nachfragen wie er sein soll;
      if isempty(inputargument) # wenn einfach nur enter gedrückt wurde dann default nehmen
        vpNummer = default.vpNummer; 
        valid= true;
      endif
      if  finite (str2double (inputargument )) ; vpNummer = str2double (inputargument)  ; valid= true;  endif
    until valid == true
  endif  
  
  # alles was string sein soll
  if isempty(outputFileStr) # is es leer (weil beim start nix angegeben wurde?)
    inputtext = 'VP-Code oder so: ';
    inputargument = input (inputtext , 's'); # nachfragen wie er sein soll
    if isempty(inputargument) # wenn einfach nur enter gedrückt wurde dann default nehmen
      outputFileStr = default.outputFileStr; 
    else
      outputFileStr= inputargument;
    endif
  endif
  
  # alles was bool sein soll
  if isempty(buttonBoxON) # is es leer (weil beim start nix angegeben wurde?)
    valid = false;
    do
      inputtext     = 'buttonbox is via default ON; do you wish to keep it that way (ENTER). Otherwise true or false: ';
      inputargument = input (inputtext , 's'); # nachfragen wie er sein soll;
      if isempty(inputargument) # wenn einfach nur enter gedrückt wurde dann default nehmen
        buttonBoxON = default.buttonBoxON; 
        valid= true;
      endif
      if strcmp( 'true'  ,inputargument ) || strcmp( 't' ,inputargument ); buttonBoxON = true  ; valid= true;  endif
      if strcmp( 'false' ,inputargument ) || strcmp( 'f' ,inputargument ); buttonBoxON = false ; valid= true;  endif
    until valid == true
  endif  
  
  if isempty(debugEnabled) # is es leer (weil beim start nix angegeben wurde?)
    valid = false;
    do
      inputtext     = 'debugEnabled is via default OFF; do you wish to keep it that way (ENTER). Otherwise true or false: ';
      inputargument = input (inputtext , 's'); # nachfragen wie er sein soll;
      if isempty(inputargument) # wenn einfach nur enter gedrückt wurde dann default nehmen
        debugEnabled = default.debugEnabled; 
        valid= true;
      endif
      if strcmp( 'true'  ,inputargument ) || strcmp( 't' ,inputargument ); debugEnabled = true  ; valid= true;  endif
      if strcmp( 'false' ,inputargument ) || strcmp( 'f' ,inputargument ); debugEnabled = false ; valid= true;  endif
    until valid == true
  endif  
  
  
  # alles was numbers sein sollen
  if isempty(screendist) # is es leer (weil beim start nix angegeben wurde?)
    valid = false;
    do
      inputtext     = 'Distance to the screen, default = 80 (ENTER). Otherwise type number: ';
      inputargument = input (inputtext , 's'); # nachfragen wie er sein soll;
      if isempty(inputargument) # wenn einfach nur enter gedrückt wurde dann default nehmen
        screendist = default.screendist; 
        valid= true;
      endif
      if  finite (str2double (inputargument )) ; screendist = str2double (inputargument)  ; valid= true;  endif
    until valid == true
  endif  

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

################################################################################
## Hardcoded stuff 
################################################################################
# der nich initialisiert wurde und nicht über die settings.csv eingelesen wird,
# in der hoffnung irgendwann das ganze mal hübsch zu machen 

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
  
  boxcolor = [192 192 192]
  boxpen   = 3

  
  

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
     WINDOWSIZE = [0 0 1279  800];  #  16:10 wu Laptop
#     WINDOWSIZE = [0 0 1679 1050];  #  16:10 wu pc
#     WINDOWSIZE = [0 0 1919 1080];  #  16:9  testrechner
     WINDOWSIZE = WINDOWSIZE -100

#  Windowed
#     WINDOWSIZE = [20 20 620 620]; # 1:1
#     WINDOWSIZE = [20 20 600 375]; # 16:10
#     WINDOWSIZE = [20 20 600 337]; # 16:9

  switch debugEnabled
    case false
      [windowPtr,rect.root] = Screen('OpenWindow', screenID )
    case true
      [windowPtr,rect.root] = Screen('OpenWindow', screenID ,[], WINDOWSIZE) # 16:9
  endswitch
  
  # tranparent alpha http://old.psychtoolbox.org/OldPsychtoolbox/wikka.php?wakka=FaqImageTransparency
  # makeTexFromInfo macht seit neusten den alpha channel dazu
  Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  HideCursor(screenID)

################################################################################
##  init buttonbox

  if buttonBoxON == true
    [handle , BBworking ] = cedrusInitUSBLinux
    buttonBoxON = BBworking # change the state of buttonBoxON to true or false depending on if the initiation was successful
  endif

################################################################################
##  textstyles

  newTextFont = 'Courier New';
  newTextSize = 20;
  newTextColor= [00 00 00];

  oldTextFont  = Screen('TextFont'  , windowPtr , newTextFont );
  oldTextSize  = Screen('TextSize'  , windowPtr , newTextSize );
  oldTextColor = Screen('TextColor' , windowPtr , newTextColor);
  
###############################################################################
## Pixelgröße berechnen  
  display =Screen('Resolution', screenID);
  [display.widthmm, display.heightmm]=Screen('DisplaySize', screenID);
  display
  onePXinMM.x=display.widthmm /display.width;
  onePXinMM.y=display.heightmm/display.height;
  onePXinMM.mean= (onePXinMM.x+onePXinMM.y)/2;
  
  
  # math
  # 1 px * onePXinMM = size in milimeters
    
# berechenn der Größe von 1 grad Mittenabweichung auf dem bildschirm
# abstand ist per default mit 80cm angegeben  
  deg1diameter.mm=tand(1)*screendist*10; # tand benutzt normale grad zahlen 
  deg1diameter.px= deg1diameter.mm/onePXinMM.mean;
  deg1s.mm = deg1diameter.mm/2
  deg1s.px = deg1diameter.px/2


################################################################################
##  settings einlesen
  rawSettingsCell = csv2cell( 'settings.csv' , ',');
  
  #stettings rotieren damit sie im csv einfacher zu lesen sind muss einfach nur noch auskommentiert werden falls das csv wieder transponiert werden sollte 
  rawSettingsCell =  rawSettingsCell'

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
#     crossSizemm
#     cueFolder
#     cueSizemm
#     cueType
#     instructionFile
#     instructionFolder
#     ratingCovering
#     ratingFile
#     ratingFolder
#     stimFolder
#     stimSizemm
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
  for BNr=1:length(def) #  BNr == blocknunber
  
    # convert sizes mm -> px
    def(BNr).crossSizepx  = def(BNr).crossSizemm / onePXinMM.mean;
    def(BNr).cueSizepx    = def(BNr).cueSizemm   / onePXinMM.mean;
    def(BNr).stimSizepx   = def(BNr).stimSizemm  / onePXinMM.mean;
    def(BNr).crossRect    = [ 0 0 def(BNr).crossSizepx  def(BNr).crossSizepx ]
    def(BNr).cueRect      = [ 0 0 def(BNr).cueSizepx    def(BNr).cueSizepx   ]
    def(BNr).stimRect     = [ 0 0 def(BNr).stimSizepx   def(BNr).stimSizepx  ]
    
    # divide zeitCue by '_' für die cue kann wegen SOA mhrere zeiten mit '_'unterteilt angegeben werden
    if ischar(def(BNr).zeitCues)
      zeittemp = strsplit (def(BNr).zeitCues , '_');
      for i=1:length(zeittemp)
	def(BNr).zeitCuesArr(i)=str2num(zeittemp(1,i){});
      endfor
    else
      def(BNr).zeitCuesArr=def(BNr).zeitCues;
    endif
    
    
    # convert times  ms -> seconds
    def(BNr).zeitBetweenpause = def(BNr).zeitBetweenpause  /1000;
    def(BNr).zeitFixcrossCue  = def(BNr).zeitFixcrossCue   /1000;
#     def(BNr).zeitCue          = def(BNr).zeitCue           /1000;
    def(BNr).zeitCuesArr      = def(BNr).zeitCuesArr       /1000;
    def(BNr).zeitFixcross     = def(BNr).zeitFixcross      /1000;
    def(BNr).zeitPrepause     = def(BNr).zeitPrepause      /1000;
    def(BNr).zeitStimuli      = def(BNr).zeitStimuli       /1000;
    def(BNr).zeitAfterpause   = def(BNr).zeitAfterpause    /1000;
    def(BNr).zeitRating       = def(BNr).zeitRating        /1000;
    
    # loding Info about pictures
    def(BNr).stimInfo         = getFilesInFolderInfo ([folder.in def(BNr).stimFolder       ] , def(BNr).stimType       ); #  stimulus Info holen
    def(BNr).cueInfo          = getFilesInFolderInfo ([folder.in def(BNr).cueFolder        ] , def(BNr).cueType        ); #  cue Info holen
    def(BNr).ratingInfo       = getFileInfo          ([folder.in def(BNr).ratingFolder     ] , def(BNr).ratingFile     ); #  rating Infos holen
    def(BNr).instructionInfo  = getFileInfo          ([folder.in def(BNr).instructionFolder] , def(BNr).instructionFile); #  instuctions info holen
    def(BNr).crossInfo        = getFileInfo  	     ([folder.in def(BNr).crossFolder      ] , def(BNr).crossFile      ); #  cross info
    
    # make the textures
    def(BNr).stimInfo          = makeTexFromInfo (windowPtr , def(BNr).stimInfo       );
    def(BNr).cueInfo           = makeTexFromInfo (windowPtr , def(BNr).cueInfo        );
    def(BNr).ratingInfo        = makeTexFromInfo (windowPtr , def(BNr).ratingInfo     );
    def(BNr).instructionInfo   = makeTexFromInfo (windowPtr , def(BNr).instructionInfo);
    def(BNr).crossInfo 	       = makeTexFromInfo (windowPtr , def(BNr).crossInfo      );
    
    # get texture sizes 
    for i=1:length(def(BNr).stimInfo)
      def(BNr).stimInfo(i).texturerect          = Screen('Rect' , def(BNr).stimInfo(i).texture        );
    endfor
    for i=1:length(def(BNr).cueInfo)
      def(BNr).cueInfo(i).texturerect           = Screen('Rect' , def(BNr).cueInfo(i).texture         );
    endfor
    for i=1:length(def(BNr).ratingInfo)
      def(BNr).ratingInfo(i).texturerect        = Screen('Rect' , def(BNr).ratingInfo(i).texture      );
    endfor
    for i=1:length(def(BNr).instructionInfo)
      def(BNr).instructionInfo(i).texturerect   = Screen('Rect' , def(BNr).instructionInfo(i).texture );
    endfor
    for i=1:length(def(BNr).crossInfo)
      def(BNr).crossInfo(i).texturerect         = Screen('Rect' , def(BNr).crossInfo(i).texture       );
    endfor
    
    def(BNr).ratingVanish      = length(def(BNr).stimInfo) / 100 * def(BNr).ratingCovering ; # ob das rating angezeigt werden soll ? # altlast
  endfor

    
################################################################################
## Positionen punkte
################################################################################



# positionen der bilder werden über den mittelpunkt angegeben 


  point.mid.x   = rect.root(3)/2;
  point.mid.y   = rect.root(4)/2;

  point.left.x  = point.mid.x + deg1s.px*7;
  point.left.y  = point.mid.y # + deg1s.px*7;

  point.right.x = point.mid.x - deg1s.px*7;
  point.right.y = point.mid.y # - deg1s.px*7;

  rect.deg1diameter = [0 0 deg1diameter.px deg1diameter.px]
#   rect.cdegree1  = CenterRectOnPoint( rect.deg1diameter ,point.mid.x , point.mid.y)

# rect.cross = [0 0 100 100]
# rect.cue   = [0 0 10 10]
# rect.stim  = [0 0 10 10]
# 
# rect.cue   = CenterRectOnPoint(rect.cue  , point.mid.x   , point.mid.y  )
# rect.stimL = CenterRectOnPoint(rect.stim , point.left.x  , point.left.y )
# rect.stimR = CenterRectOnPoint(rect.stim , point.right.x , point.right.y)

  
################################################################################
## absolute positionen
################################################################################
# überbleibsel aus 1 aber ganz praktisch
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

#   #                 x                y            x                y
#   rect.L1 = [ x.imgLeftStart  y.imgTopStart  x.imgLeftEnd  y.imgTopEnd ];
#   rect.L2 = [ x.imgLeftStart  y.imgMidStart  x.imgLeftEnd  y.imgMidEnd ];
#   rect.L3 = [ x.imgLeftStart  y.imgBotStart  x.imgLeftEnd  y.imgBotEnd ];
#   rect.M1 = [ x.imgMidStart   y.imgTopStart  x.imgMidEnd   y.imgTopEnd ];
#   rect.M2 = [ x.imgMidStart   y.imgMidStart  x.imgMidEnd   y.imgMidEnd ];
#   rect.M3 = [ x.imgMidStart   y.imgBotStart  x.imgMidEnd   y.imgBotEnd ];
#   rect.R1 = [ x.imgRightStart y.imgTopStart  x.imgRightEnd y.imgTopEnd ];
#   rect.R2 = [ x.imgRightStart y.imgMidStart  x.imgRightEnd y.imgMidEnd ];
#   rect.R3 = [ x.imgRightStart y.imgBotStart  x.imgRightEnd y.imgBotEnd ];
# 
#   positonArray(1) = {rect.M2};
#   positonArray(2) = {rect.L1};
#   positonArray(3) = {rect.L3};
#   positonArray(4) = {rect.R1};
#   positonArray(5) = {rect.R3};

  rect.instructions =  [ x.imgLeftStart  y.imgTopStart  x.imgRightEnd y.imgMidEnd ];
  rect.rating       =  [ x.imgLeftStart  y.imgBotStart  x.imgRightEnd y.imgBotEnd ];
  rect.cross        =  [ x.imgMidStart   y.imgMidStart  x.imgMidEnd   y.imgMidEnd ];


################################################################################
## Randomisierung NEU
################################################################################
# jeder Stim muss ja 2 mal präsentiert werden für jeden cue 

  for BNr=1:length(def)
    QUAcue = length(def(BNr).cueInfo); # wie viele cues gibst
    QUAstim= length(def(BNr).stimInfo); # wie viele stimuli sind in stimInfo
    QUApos = 2
    QUAsoa = length(def(BNr).zeitCuesArr) #stimulus onset asynchrony
#     QUAcue = 5
#     QUAstim= 2
#     QUApos = 2
#     QUAsoa = 3
    

    # insgesammt wird es am ende cue * 2 * stimulus tails geben
    # cue * 2 da bei spatial cueing jeder stimulus sowohl rechts als auch links angezeigt wird (detection task)
    
    C= 1:QUAcue; # array erstellen der 
    S= 1:QUAstim; 
    P= 1:QUApos; # zwei possitionen l u R
    A= 1:QUAsoa;
    
   
    CSPA  =  allcomb(C,S,P,A);
    
    [CSPAr , nextSeed ] = randomizeCol( CSPA , nextSeed , 1 );
    
    def(BNr).randMatrix  = CSPAr;
    def(BNr).randColCue  = CSPAr(:,1);
    def(BNr).randColStim = CSPAr(:,2);
    def(BNr).randColPos  = CSPAr(:,3);
    def(BNr).randColTime = CSPAr(:,4);
    
    for i=1:length(def(BNr).randMatrix)
      def(BNr).EXcueInfo(i)  = def(BNr).cueInfo ( CSPAr(i,1) ); # infos zu den ex infos in der richtigen reihenfolge zusammenkopieren
      def(BNr).EXstimInfo(i) = def(BNr).stimInfo( CSPAr(i,2) );
    endfor
    
    for i=1:length(def(BNr).EXcueInfo)
      def(BNr).EXcueInfo(i).zeit = def(BNr).zeitCuesArr (CSPAr(i,4));
    endfor
    
  endfor

################################################################################
## berechnen der skalierten Bilder + Lokalisation NEU
################################################################################

  # Finale positionen feststellen
  for i=1:length(def) #  i == blocknunber
    def(i).FINcrossRect      = CenterRectOnPoint( def(i).crossRect , point.mid.x   , point.mid.y   );
    def(i).FINcueRect        = CenterRectOnPoint( def(i).cueRect   , point.mid.x   , point.mid.y   );
    def(i).FINstimRectleft   = CenterRectOnPoint( def(i).stimRect  , point.left.x  , point.left.y  );
    def(i).FINstimRectright  = CenterRectOnPoint( def(i).stimRect  , point.right.x , point.right.y );
    def(i).FRAMEcrossRect      = CenterRectOnPoint( def(i).crossRect *1.20 , point.mid.x   , point.mid.y   );
    def(i).FRAMEcueRect        = CenterRectOnPoint( def(i).cueRect   *1.20 , point.mid.x   , point.mid.y   );
    def(i).FRAMEstimRectleft   = CenterRectOnPoint( def(i).stimRect  *1.20 , point.left.x  , point.left.y  );
    def(i).FRAMEstimRectright  = CenterRectOnPoint( def(i).stimRect  *1.20 , point.right.x , point.right.y );
  endfor
  
  #skalierung für alles singuläre
  for i=1:length(def)
    def(i).ratingInfo.finrect       = putRectInRect (rect.rating         , def(i).ratingInfo.texturerect);
    def(i).instructionInfo.finrect  = putRectInRect (rect.instructions   , def(i).instructionInfo.texturerect);
    def(i).crossInfo.finrect        = putRectInRect (def(i).FINcrossRect , def(i).crossInfo.texturerect);
  endfor
  
  #skalierung für alles multible
  for i=1:length(def)
  
    for j= 1:length(def(i).EXstimInfo);
    
      switch def(i).randColPos(j)
        case 1
          def(i).EXstimInfo(j).finrect = putRectInRect (def(i).FINstimRectleft  , def(i).EXstimInfo(j).texturerect);
          def(i).EXstimInfo(j).position     = 'left';
        case 2
          def(i).EXstimInfo(j).finrect = putRectInRect (def(i).FINstimRectright , def(i).EXstimInfo(j).texturerect);
          def(i).EXstimInfo(j).position     = 'right';
      endswitch
      
    endfor
    
    for j= 1:length(def(i).EXcueInfo)
      def(i).EXcueInfo(j).finrect       = putRectInRect (def(i).FINcueRect , def(i).EXcueInfo(j).texturerect);
    endfor
    
  endfor

################################################################################
## render testscreens
  switch debugEnabled
    case true
      infotainment(windowPtr , '1-20°')
        Screen('FillRect', windowPtr , [255 191 000] , def(1).FINcrossRect      );
        Screen('FillRect', windowPtr , [255 126 000] , def(1).FINstimRectleft   );
        Screen('FillRect', windowPtr , [245 215 000] , def(1).FINstimRectright  );
#         Screen('FillRect', windowPtr , [255 191 000] , def(1).FINcueRect        );
	Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectleft  , boxpen );
	Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectright , boxpen );
	Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEcueRect       , boxpen );
	for i=1:20
	  drawme= CenterRectOnPoint( rect.deg1diameter*i ,point.mid.x , point.mid.y);
	  Screen('FrameOval', windowPtr , [255 20 147] , drawme);
	endfor
      
      
      Screen('Flip', windowPtr)
        KbPressWait;
      Screen('Flip', windowPtr)

#       infotainment(windowPtr , 'testscreen upcomming')
#         Screen('FillRect', windowPtr , [255 20 147] , rect.L1  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.L2  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.L3  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.M1  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.M2  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.M3  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.R1  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.R2  );
#         Screen('FillRect', windowPtr , [255 20 147] , rect.R3  );


#       Screen('Flip', windowPtr)
#         KbPressWait;
#       Screen('Flip', windowPtr)

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
# MAINPART: THE MIGHTY EXPERIMENT
################################################################################
  [empty, empty , startFLIP ] =Screen('Flip', windowPtr); # get thei first flip
  
  superIndex = 0; # index über alle Durchläufe hinweg
  
  for WHATBLOCK=1:BLOCKS  # für alle definierten Blöcke
    instruTime= GetSecs+3600; # eine stunde
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).instructionInfo.texture , [] , def(WHATBLOCK).instructionInfo.finrect);
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).ratingInfo.texture      , [] , def(WHATBLOCK).ratingInfo.finrect      );
      Screen('Flip', windowPtr);
      WaitSecs(10)
    for i=1:2
      Screen('DrawText'    , windowPtr , int2str(i) , 50 , 50)
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).instructionInfo.texture , [] , def(WHATBLOCK).instructionInfo.finrect);
      Screen('DrawTexture' , windowPtr , def(WHATBLOCK).ratingInfo.texture      , [] , def(WHATBLOCK).ratingInfo.finrect      );
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
    m = length(def(WHATBLOCK).EXstimInfo);
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
# 	  drawFixCross (windowPtr , [18 18 18] , x.center , y.center , 80 , 2 );
	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).crossInfo.texture , [] , def(WHATBLOCK).crossInfo.finrect );
	  Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectleft  , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectright , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEcueRect       , boxpen );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitFixcrossCue;
	  
	  timeStamp.flipFixCue = lastFLIP; 
        else
          #timeStamp.flipFixCue = NA; 
          timeStamp.flipFixCue = lastFLIP; 
      endif
        
      # CUE
      if def(WHATBLOCK).EXcueInfo(INBLOCK).zeit > 0
	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).EXcueInfo(INBLOCK).texture , [] , def(WHATBLOCK).EXcueInfo(INBLOCK).finrect );
	  Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectleft  , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectright , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEcueRect       , boxpen );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).EXcueInfo(INBLOCK).zeit;
	  
	  timeStamp.flipCue = lastFLIP; 
	else
	  #timeStamp.flipCue = NA; 
	  timeStamp.flipCue = lastFLIP;
       endif
        
      
      # FIXCROSS
      if def(WHATBLOCK).zeitFixcross > 0
# 	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).crossInfo.texture , [] , def(WHATBLOCK).crossInfo.finrect );
	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).EXcueInfo(INBLOCK).texture , [] , def(WHATBLOCK).EXcueInfo(INBLOCK).finrect );
	  Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectleft  , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectright , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEcueRect       , boxpen );
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
	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).EXstimInfo(INBLOCK).texture , [] , def(WHATBLOCK).EXstimInfo(INBLOCK).finrect );
# 	  Screen('DrawTexture', windowPtr, def(WHATBLOCK).EXcueInfo(INBLOCK).texture , [] , def(WHATBLOCK).EXcueInfo(INBLOCK).finrect );
	  Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectleft  , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectright , boxpen );
          Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEcueRect       , boxpen );
	  #flip
	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
	  nextFlip = lastFLIP + def(WHATBLOCK).zeitStimuli;

	  timeStamp.flipStim = lastFLIP;
        else
	  #timeStamp.flipStim = NA;
	  timeStamp.flipStim = lastFLIP;
      endif

#       # PAUSE AFTER
#       if def(WHATBLOCK).zeitAfterpause > 0
# 	  #flip
# 	  [empty, empty , lastFLIP ] =Screen('Flip', windowPtr , nextFlip);
# 	  nextFlip = lastFLIP + def(WHATBLOCK).zeitAfterpause;
# 
# 	  timeStamp.flipAfter = lastFLIP;
# 	else
# 	  #timeStamp.flipAfter = NA;
# 	  timeStamp.flipAfter = lastFLIP;
#       endif
      
      # RATING
        if INBLOCK< def(WHATBLOCK).ratingVanish
          Screen( 'DrawTexture' , windowPtr , def(WHATBLOCK).ratingInfo.texture , [] , def(WHATBLOCK).ratingInfo.finrect ,[], [], [], [255 255 255 0]);
          # hier noch mit der modulateColor rumspielen ob mann das rating nicht rausfaden lassen kann ;)
        endif
        Screen('DrawTexture', windowPtr, def(WHATBLOCK).EXstimInfo(INBLOCK).texture , [] , def(WHATBLOCK).EXstimInfo(INBLOCK).finrect );
# 	Screen('DrawTexture', windowPtr, def(WHATBLOCK).EXcueInfo(INBLOCK).texture , [] , def(WHATBLOCK).EXcueInfo(INBLOCK).finrect );
        Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectleft  , boxpen );
        Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEstimRectright , boxpen );
        Screen('FrameRect', windowPtr , boxcolor , def(1).FRAMEcueRect       , boxpen );
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
      dauer.stimulus            = timeStamp.flipRating - timeStamp.flipStim    ;

      dauer.rating              = pressedButtonTime    - timeStamp.flipRating  ;
      dauer.reactionTimeStimON  = pressedButtonTime    - timeStamp.flipStim    ;
      dauer.reactionTimeStimOFF = pressedButtonTime    - timeStamp.flipRating  ;


      #    dem outputfile werte zuweisen
      OUThead        =       { ...
        'vpNummer'           , ...
        'vpCode'             , ...
        'indexSuper'         , ...
        'indexBlock'         , ...
        'indexInnerBlock'    , ...
        'blockNumber'        , ...
        'blockName'          , ...
        'blockInstruction'   , ...
        'blockRating'        , ...
        'cue'		     , ...
        'cueDauer'           , ...  # laut settings
        'stimulus'           , ...
        'stimulusPosition'   , ...
        'ratingTaste'        , ...
        'ratingWert'         , ...
        'reactionStimON'     , ...
        'reactionStimOFF'    , ...
        'dauerBetween'       , ...
        'dauerFixCue'        , ...
        'dauerCue'           , ...
        'dauerFix'           , ...
        'dauerPre'           , ...
        'dauerStim'          , ...
        'dauerRating'        };

      OUTcell(superIndex,:) =                      { ...
        vpNummer                                   , ...
        outputFileStr                              , ...
        num2str(superIndex)                        , ...
        num2str(WHATBLOCK)                         , ...
        num2str(INBLOCK)                           , ...
        def(WHATBLOCK).blockNumber                 , ...
        def(WHATBLOCK).blockName                   , ...
        def(WHATBLOCK).instructionInfo.name        , ... 
        def(WHATBLOCK).ratingInfo.name             , ...
        def(WHATBLOCK).EXcueInfo(INBLOCK).name     , ...
        def(WHATBLOCK).EXcueInfo(INBLOCK).zeit    , ...
        def(WHATBLOCK).EXstimInfo(INBLOCK).name    , ...
        def(WHATBLOCK).EXstimInfo(INBLOCK).position, ...
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

# endfunction

