import chroma, vmath
# typography

when not defined(js):
  import typography/textboxes

const
  clearColor* = color(0,0,0,0)
  whiteColor* = color(1,1,1,1)
  blackColor* = color(0,0,0,1)

type
  Contraints* = enum
    cMin
    cMax
    cScale
    cStretch
    cCenter

  TextStyle* = object
    fontFamily*: string
    fontSize*: float
    fontWeight*: float
    lineHeight*: float
    textAlignHorizontal*: int
    textAlignVertical*: int

  BorderStyle* = object
    color*: Color
    width*: float

  ShadowStyle* = enum
    DropShadow
    InnerShadow

  Shadow* = object
    kind*: ShadowStyle
    blur*: float
    x*: float
    y*: float
    color*: Color

  Group* = ref object
    id*: string
    idPath*: string
    kind*: string
    text*: string
    placeholder*: string
    code*: string
    kids*: seq[Group]
    box*: Rect
    orgBox*: Rect
    rotation*: float
    screenBox*: Rect
    textOffset*: Vec2
    fill*: Color
    transparency*: float
    strokeWeight*: float
    stroke*: Color
    zLevel*: int
    resizeDone*: bool
    htmlDone*: bool
    textStyle*: TextStyle
    textPadding*: int
    imageName*: string
    cornerRadius*: (float, float, float, float)
    wasDrawn*: bool # was group drawn or it still needs to be drawn
    editableText*: bool
    multiline*: bool
    drawable*: bool
    cursorColor*: Color
    highlightColor*: Color
    shadows*: seq[Shadow]

  KeyState* = enum
    Empty
    Up
    Down
    Repeat
    Press # used for text input

  MouseCursorStyle* = enum
    Default
    Pointer
    Grab
    NSResize

  Mouse* = ref object
    state: KeyState
    pos*: Vec2
    click*: bool # mouse button just got held down
    rightClick*: bool # mouse right click
    down*: bool # mouse button is held down
    cursorStyle*: MouseCursorStyle # sets the mouse cursor icon

  Keyboard* = ref object
    state*: KeyState
    keyCode*: int
    scanCode*: int
    keyString*: string
    altKey*: bool
    ctrlKey*: bool
    shiftKey*: bool
    superKey*: bool
    inputFocusIdPath*: string
    prevInputFocusIdPath*: string
    input*: string
    textCursor*: int # at which character in the input string are we
    selectionCursor*: int # to which character are we selecting to

  Perf* = object
    drawMain*: float
    numLowLevelCalls*: int

  Window* = ref object
    innerTitle*: string
    innerUrl*: string

var
  window* = Window()
  parent*: Group
  root*: Group
  prevRoot*: Group
  groupStack*: seq[Group]
  current*: Group
  scrollBox*: Rect
  scrollBoxMega*: Rect # scroll box is 500px biger in y direction
  scrollBoxMini*: Rect # scroll box is smaller by 100px usefull for debugggin

  ## Set to true so that it repains every frame, used for:
  ##   games and multimidia with animations apps.
  ## Set to false so that it repains only following user action, used for:
  ##   animationless UI apps.
  repaintEveryFrame*: bool = true
  mouse* = Mouse()
  keyboard* = Keyboard()
  perf*: Perf
  requestedFrame*: bool
  numGroups*: int
  rootUrl*: string
  popupActive*: bool
  inPopup*: bool
  #fonts* = newTable[string, Font]()

  windowSize*: Vec2
  windowFrame*: Vec2
  dpi*: float

when not defined(js):
  var
    textBox*: TextBox

mouse = Mouse()
mouse.pos = Vec2()

proc setupRoot*() =
  prevRoot = root
  root = Group()
  groupStack = @[root]
  current = root
  root.kind = "group"
  root.id = "root"
  root.highlightColor = rgba(0, 0, 0, 20).color
  root.cursorColor = rgba(0, 0, 0, 255).color

proc use*(keyboard: Keyboard) =
  keyboard.state = Empty
  keyboard.keyCode = 0
  keyboard.scanCode = 0
  keyboard.keyString = ""
  keyboard.altKey = false
  keyboard.ctrlKey = false
  keyboard.shiftKey = false
  keyboard.superKey = false

proc use*(mouse: Mouse) =
  mouse.click = false
