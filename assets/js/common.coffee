class @Common
  @diffCoder    = new DiffCoder()
  @storage      = new SNStorage()
  @permStorage  = new SNStorage("perm")
  @titleChanger = new TitleChanger()

  @settings =
    basicTitle            : "Crunchat.com"
    maxStringLength       : 32
    anonymousIdRange      : [10000, 99999]
    roomNameAttr          : "data-room-name"
    roomIdPrefix          : "room-"
    textStoragePrefix     : "text:"

  @DOM =
    title                : $("title")
    navSpace             : $("#nav-space")
    mainSpace            : $("#main-space")
    lobbyNavTab          : $("#nav-lobby")
    lobby                : $("#lobby")
    lobbyInfo            : $("#lobby-info")
    mainSpinner          : document.getElementById("main-spinner")
    roomNameInput        : $("#room-name")
    joinForm             : $("#join-form")
    joinButton           : $("#join-button")
    randomButton         : $("#random-button")
    nicknameChangeButton : $("#nickname-change-btn")
    nicknameInput        : $("#nickname")

  @classes =
    navTab               : "nav-tab"
    navRoom              : "nav-room"
    roomSpace            : "room-space"
    roomControl          : "room-control"
    closeButton          : "btn-close"
    roomPrivacyCheckbox  : "room-privacy-checkbox"
    myBox                : "my"
    fullBox              : "full"
    halfBox              : "half"
    firstHalfBox         : "first-half"
    secondHalfBox        : "second-half"
    userSpace            : "user-space"

  @spinnerOpts =
    lines:      11        # The number of lines to draw
    length:     1         # The length of each line
    width:      4         # The line thickness
    radius:     7         # The radius of the inner circle
    corners:    1         # Corner roundness (0..1)
    rotate:     0         # The rotation offset
    color:      "#000"    # #rgb or #rrggbb
    speed:      1.3       # Rounds per second
    trail:      91        # Afterglow percentage
    shadow:     false     # Whether to render a shadow
    hwaccel:    false     # Whether to use hardware acceleration
    className:  "spinner" # The CSS class to assign to the spinner
    zIndex:     2e9       # The z-index (defaults to 2000000000)
    top:        "auto"    # Top position relative to parent in px
    left:       "auto"    # Left position relative to parent in px

  @spinner = new Spinner(@spinnerOpts)
