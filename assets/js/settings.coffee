class @Settings
  @maxStringLength   = 32
  @anonymousIdRange  = [10000, 99999]
  @roomNameAttr      = "data-room-name"
  @roomIdPrefix      = "room-"
  @textStoragePrefix = "text:"

  @ids =
    navSpace             : "nav-space"
    lobby                : "lobby"
    lobbyNavTab          : "nav-lobby"
    roomNameInput        : "room-name"
    joinButton           : "join-button"
    randomButton         : "random-button"
    nicknameChangeButton : "nickname-change-btn"
    nicknameInput        : "nickname"
    mainSpace            : "main-space"

  @classes =
    navTab        : "nav-tab"
    roomSpace     : "room-space"
    closeButton   : "btn-close"
    myBox         : "my"
    fullBox       : "full"
    halfBox       : "half"
    firstHalfBox  : "first-half"
    secondHalfBox : "second-half"
    userSpace     : "user-space"