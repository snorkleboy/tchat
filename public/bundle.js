/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 1);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

// var payloadd = {
//     username: 'timlkjkh',
//     password: 'passsssssss'
// };

var login = exports.login = function login(payload) {
    return fetch("http://localhost:3000/api/login", {
        method: "POST",
        body: JSON.stringify(payload)
    }).then(function (res) {
        return res.json().then(function (data) {
            if (res.ok) {
                return data;
            } else {
                throw new Error(data.error);
            }
        });
    });
};

var signup = exports.signup = function signup(payload) {
    return fetch("http://localhost:3000/api/signup", {
        method: "POST",
        body: JSON.stringify(payload)
    }).then(function (res) {
        return res.json().then(function (data) {
            if (res.ok) {
                return data;
            } else {
                throw new Error(data.error);
            }
        });
    });
};

var guest = exports.guest = function guest() {
    return fetch("http://localhost:3000/api/login", {
        method: "POST",
        body: JSON.stringify({ 'username': 'guest', 'password': 'password' })
    }).then(function (res) {
        return res.json().then(function (data) {
            if (res.ok) {
                return data;
            } else {
                throw new Error(data.error);
            }
        });
    });
};
var isUser = exports.isUser = function isUser(payload) {
    return fetch("http://localhost:3000/api/isuser", {
        method: "POST",
        body: JSON.stringify(payload)
    }).then(function (res) {
        return res.json();
    });
};

var auth = function auth() {
    return fetch("http://localhost:3000/api/login", {
        method: "POST",
        body: JSON.stringify(payload)
        //auth headers  //  // headers: new Headers({ 'authentication': 'jwt start' })
    }).then(function (res) {
        return res.json();
    }).then(function (data) {
        console.log(JSON.stringify(data));
    });
};

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _store = __webpack_require__(2);

var _store2 = _interopRequireDefault(_store);

var _WS = __webpack_require__(4);

var _WS2 = _interopRequireDefault(_WS);

var _API = __webpack_require__(0);

var _auth = __webpack_require__(3);

var _auth2 = _interopRequireDefault(_auth);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var startup = function startup() {
    var store = new _store2.default();
    var signinSubmit = document.getElementById('signin-submit');
    var handlein = document.getElementById('handle-Signin');
    handlein.focus();
    var appholder = document.getElementById('appholder');
    var signin = document.getElementById('signin');
    var guestSignIn = document.getElementById('signin-guest');

    var signinClickHandle = function signinClickHandle() {
        console.log('login attempt', handlein.value);
        var handle = handlein.value.replace(/\s+/g, '');
        console.log(_auth2.default);
        handlein.value = '';
        _auth2.default.passwordSetup(handle, store);
        signinSubmit.removeEventListener('click', signinClickHandle);
    };
    signinSubmit.addEventListener('click', signinClickHandle);

    guestSignIn.addEventListener('click', function () {
        (0, _API.guest)().then(function (res) {
            signinSubmit.removeEventListener('click', signinClickHandle);
            console.log(res);
            _auth2.default.finalize('guest', store, res);
        });
    });
};

document.addEventListener('DOMContentLoaded', startup);

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _ui = __webpack_require__(5);

var _ui2 = _interopRequireDefault(_ui);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var Store = function Store() {
    this.ui = new _ui2.default(this);
    this.handle = '';
    this.room = 'general';
    this.signedIn = false;
    this.store = {};
    this.rooms = {};
    this.userList = {};
    this.msgs = [];
    this.setRoom = this.setRoom.bind(this);
    this.handleName = this.handleName.bind(this);
    this.roomName = this.roomName.bind(this);
};

Store.prototype.setHandle = function (handle) {
    this.handle = handle;
    this.ui.makeName(handle);
};
Store.prototype.setRoom = function (room) {
    this.room = room;
    this.ui.makeRoom(room);
};
Store.prototype.changeUserlist = function (rooms, userList) {
    this.userList = userList;
    this.rooms = rooms;
    this.ui.makeUserList(rooms);
};

Store.prototype.roomName = function () {
    return this.room;
};
Store.prototype.handleName = function () {
    return this.handle;
};

exports.default = Store;

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _WS = __webpack_require__(4);

var _WS2 = _interopRequireDefault(_WS);

var _API = __webpack_require__(0);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var diffUserButton = document.createElement('input');

var authSeq = function authSeq() {
    this.passwordSetup = this.passwordSetup.bind(this);
    this.changeToLogin = this.changeToLogin.bind(this);
    this.changeToSignUp = this.changeToSignUp.bind(this);
};
authSeq.prototype.passwordSetup = function (handle, store) {
    var _this = this;

    (0, _API.isUser)({ "username": handle }).then(function (res) {
        var signinButtons = document.getElementById('signin-buttons');
        var anotherUserButton = document.createElement('INPUT');
        anotherUserButton.type = 'submit';
        anotherUserButton.value = 'Another User';
        anotherUserButton.id = 'anotherUserButton';
        anotherUserButton.addEventListener('click', _this.signInInitialHandleMaker(store));

        var a = signinButtons.appendChild(anotherUserButton);
        console.log(signinButtons, anotherUserButton, a.parentElement);
        console.log('registered:', res.isuser);
        if (res.isuser) {
            _this.changeToLogin(handle, store);
        } else {
            _this.changeToSignUp(handle, store);
        }
    });
};

authSeq.prototype.finalize = function (handle, store, token) {
    store.setHandle(handle.length > 1 ? handle : 'anon');
    store.signedIn = true;
    appholder.classList.remove('blur');
    signin.style.display = 'none';
    var signinSubmit = document.getElementById('signin-submit');
    signinSubmit.parentElement.removeChild(signinSubmit);
    (0, _WS2.default)(store, token);
};

authSeq.prototype.changeToSignUp = function (handle, store) {
    var _this2 = this;

    var input = document.getElementById('handle-Signin');
    input.placeholder = 'enter Password';

    var signin = document.getElementById('signin');
    var text = signin.querySelector('h1');
    text.innerText = '-' + handle + '- not registered, enter a password to create an account or press guest';

    var signinSubmit = document.getElementById('signin-submit');
    signinSubmit.addEventListener('click', function () {
        console.log("signing", input.value);
        (0, _API.signup)({ username: handle, password: input.value }).then(function (res) {
            console.log(res);
            _this2.finalize(handle, store, res);
        }, function (fail) {
            console.log('failure:', fail);
            text.innerText = fail;
        });
    });
};

authSeq.prototype.changeToLogin = function (handle, store) {
    var _this3 = this;

    var input = document.getElementById('handle-Signin');
    input.placeholder = 'enter Password';

    var signin = document.getElementById('signin');
    var text = signin.querySelector('h1');
    text.innerText = 'welcome back, -' + handle + '- , please enter password';

    var signinSubmit = document.getElementById('signin-submit');
    signinSubmit.addEventListener('click', function () {
        console.log("login", input.value);
        console.log((0, _API.login)({ username: handle, password: input.value }));
        (0, _API.login)({ username: handle, password: input.value }).then(function (res) {
            console.log(res);
            _this3.finalize(handle, store, res);
        }, function (fail) {
            console.log(fail);
            text.innerText = fail;
        });
    });
};

authSeq.prototype.signInInitialHandleMaker = function (store) {
    return function () {
        var anotherUserButton = document.getElementById('anotherUserButton');
        anotherUserButton.parentElement.removeChild(anotherUserButton);

        var signinSubmit = document.getElementById('signin-submit');
        var clone = signinSubmit.cloneNode();
        signinSubmit.parentElement.replaceChild(clone, signinSubmit);
        signinSubmit = clone;
        var handlein = document.getElementById('handle-Signin');
        handlein.focus();
        var appholder = document.getElementById('appholder');
        var signin = document.getElementById('signin');
        var signedIn = false;

        var input = document.getElementById('handle-Signin');
        input.placeholder = 'enter username';
        var text = signin.querySelector('h1');
        text.innerText = 'Welcome To Chat, please enter a name or press guest';

        var signinClickHandle = function signinClickHandle() {
            console.log('login attempt', handlein.value);
            var handle = handlein.value.replace(/\s+/g, '');
            console.log(authseq);
            handlein.value = '';
            authseq.passwordSetup(handle, store);
            signinSubmit.removeEventListener('click', signinClickHandle);
        };
        signinSubmit.addEventListener('click', signinClickHandle);
    };
};
var authseq = new authSeq();
exports.default = authseq;

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});


var WSmaker = function WSmaker(store) {
    // console.log('loaded');
    var subBtn = document.getElementById('submit');
    var handle = store.handle;
    var input = document.getElementById('chatin');
    input.focus();
    var messageBox = document.getElementById('messageBox');

    var roomChangeInput = document.getElementById('roomChangeInput');
    var roomChangeButton = document.getElementById('roomChangeButton');

    var scheme = "ws://";
    var uri = scheme + window.document.location.host + "/" + handle;
    var ws = new WebSocket(uri);

    ws.onmessage = function (msg) {
        var data = JSON.parse(msg.data);
        if (data.action === 'msg') {
            var msgEl = document.createElement('li');
            msgEl.innerHTML = '\n        <h1>' + data.handle + ': ' + data.text + '</h1>\n        ';
            messageBox.appendChild(msgEl);
            bottomizeScroll();
        } else {
            console.log('RECEIVED WS COMMAND', data.action, data.payload, data);
            switch (data.action) {
                case "userList":
                    store.changeUserlist(data.payload.rooms, data.payload.userList);
                    break;
                default:
                    console.log('unknown action', data);
            }
        }
    };

    ws.onerror = function (err) {
        console.log('web socket error', err);
    };

    ws.onclose = function (e) {
        console.log('websocket closing', e);
    };

    ws.onopen = function (e) {};

    // send message
    subBtn.addEventListener('click', function (e) {

        e.preventDefault();
        var text = input.value;

        console.log('submit clicked', handle, text);

        ws.send(JSON.stringify({
            action: 'msg',
            room: store.roomName(),
            handle: handle,
            text: text
        }));

        var msgEl = document.createElement('li');
        msgEl.innerHTML = '\n        <h1>' + handle + ': ' + text + '</h1>\n        ';
        msgEl.classList.add('myMessage');
        messageBox.appendChild(msgEl);
        bottomizeScroll();

        input.value = "";
        input.select();
    });
    //send message by pressing enter
    document.addEventListener('keypress', function (e) {
        if (e.key == 'Enter') {
            subBtn.click();
        }
    });

    //change rooms
    roomChangeButton.addEventListener('click', function (e) {
        store.setRoom(roomChangeInput.value);
        roomChangeInput.value = '';
        ws.send(JSON.stringify({
            action: 'roomChange',
            payload: {
                room: store.room
            }
        }));
    });
};

function bottomizeScroll() {
    var element = document.getElementById("messages");
    element.scrollTop = element.scrollHeight;
}

exports.default = WSmaker;

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var UI = function () {
    function UI(store) {
        _classCallCheck(this, UI);

        this.store = store;

        //makes room list collapseable on each room
        document.getElementById('userlistLabel').addEventListener('click', function (e) {
            document.querySelectorAll('.room').forEach(function (roomButton) {
                roomButton.classList.contains('collapse') ? roomButton.classList.remove('collapse') : roomButton.classList.add('collapse');
            });
        });

        //binds enter to signinbutton at start
        var signInEnter = function signInEnter(e) {
            if (!store.signedIn && e.key == 'Enter') {
                var signinSubmitel = document.getElementById('signin-submit');
                signinSubmitel.click();
            } else if (store.signedIn) {
                document.removeEventListener('keypress', signInEnter);
            }
        };
        document.addEventListener('keypress', signInEnter);
    }

    _createClass(UI, [{
        key: 'makeName',
        value: function makeName(handle) {
            var username = document.getElementById('username');
            username.innerHTML = '<h1>' + handle + '</h1>';
        }
    }, {
        key: 'makeRoom',
        value: function makeRoom(roomName) {
            var roomname = document.getElementById('roomname');
            document.getElementById('roomname').innerHTML = '<h1>' + roomName + '</h1>';
        }
    }, {
        key: 'makeUserList',
        value: function makeUserList(rooms) {
            var userListEl = document.getElementById('userList');
            userListEl.innerHTML = '';

            var roomChangeInput = document.getElementById('roomChangeInput');
            var roomChangeButton = document.getElementById('roomChangeButton');

            Object.keys(rooms).forEach(function (room, i) {

                //this is a li for a single room. It will have a collapse button and a list of users.  
                var roomEl = document.createElement('li');
                roomEl.innerHTML = '\n            <div>\n                <button \n                id=roomButton \n                data-room=' + room + '>\n                    ' + room + '\n                </button>\n                <button\n                data-room=' + room + ' \n                id=\'collapseRoom\'>\n                    [x]\n                </button>\n            </div>\n            ';
                roomEl.classList.add('room');
                //adds a collapse event to the roomels second button which collapses its user list
                roomEl.querySelector('#collapseRoom').addEventListener('click', function (e) {
                    roomEl.classList.contains('collapse') ? roomEl.classList.remove('collapse') : roomEl.classList.add('collapse');
                });

                //this is the list of users the roomEl will have
                var roomElList = document.createElement('ul');
                roomElList.classList.add('roomUserList');

                roomEl.appendChild(roomElList);
                userListEl.appendChild(roomEl);

                //go through every user in this room and make a new li for them and append to the roomellist
                rooms[room].forEach(function (user) {
                    var li = document.createElement('li');
                    li.innerHTML = '<button id=\'userButton\' data-name=' + user.name + '\'>' + user.name + '</button>';
                    roomElList.appendChild(li);
                });

                //clicking on a roomname will make change the room by putting that roomname into the roomname change input element and clicking its submit button
                document.querySelectorAll('#roomButton').forEach(function (button) {
                    button.addEventListener('click', function (e) {
                        roomChangeInput.value = button.dataset.room;
                        roomChangeButton.click();
                    });
                });
                //this is for clicking a username
                //will later impliment direct messenging and freinds. 
                document.querySelectorAll('#userButton').forEach(function (button) {
                    button.addEventListener('click', function (e) {
                        console.log(button.dataset.name);
                    });
                });
            });
        }
    }]);

    return UI;
}();

exports.default = UI;

/***/ })
/******/ ]);
//# sourceMappingURL=bundle.js.map