class @Common
  @diffCoder   = new DiffCoder()
  @storage     = new SNStorage()
  @permStorage = new SNStorage("perm")

  @settings =
    maxStringLength       : 32
    anonymousIdRange      : [10000, 99999]
    roomNameAttr          : "data-room-name"
    roomIdPrefix          : "room-"
    textStoragePrefix     : "text:"

  @DOM =
    navSpace             : $("#nav-space")
    mainSpace            : $("#main-space")
    lobbyNavTab          : $("#nav-lobby")
    lobby                : $("#lobby")
    roomNameInput        : $("#room-name")
    joinButton           : $("#join-button")
    randomButton         : $("#random-button")
    nicknameChangeButton : $("#nickname-change-btn")
    nicknameInput        : $("#nickname")

  @classes =
    navTab               : "nav-tab"
    roomSpace            : "room-space"
    closeButton          : "btn-close"
    myBox                : "my"
    fullBox              : "full"
    halfBox              : "half"
    firstHalfBox         : "first-half"
    secondHalfBox        : "second-half"
    userSpace            : "user-space"
