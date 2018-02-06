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
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _store = __webpack_require__(1);

var _store2 = _interopRequireDefault(_store);

var _WS = __webpack_require__(2);

var _WS2 = _interopRequireDefault(_WS);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

document.addEventListener('DOMContentLoaded', function () {

    var signinSubmit = document.getElementById('signin-submit');
    var handlein = document.getElementById('handle-Signin');
    handlein.focus();
    var appholder = document.getElementById('appholder');
    var signin = document.getElementById('signin');
    var signedIn = false;
    var username = document.getElementById('username');
    var roomname = document.getElementById('roomname');
    //one time event
    //binds enter to signin button then unbinds it (it gets rebound to submit messages)
    var signInEnter = function signInEnter(e) {
        if (e.key == 'Enter' && !signedIn) {
            var signinSubmitel = document.getElementById('signin-submit');
            signinSubmitel.click();
            document.removeEventListener('keypress', signInEnter);
        }
    };
    document.addEventListener('keypress', signInEnter);

    //sets name in store and intializes websocket connection
    signinSubmit.addEventListener('click', function () {
        signedIn = true;
        _store2.default.handle = handlein.value.length > 1 ? handlein.value : 'anon';
        username.innerHTML = '<h1>' + _store2.default.handle + '</h1>';
        roomname.innerHTML = '<h1>' + _store2.default.roomName() + '</h1>';
        (0, _WS2.default)(_store2.default);
        appholder.classList.remove('blur');
        signin.style.display = 'none';
    });
    document.getElementById('userlistLabel').addEventListener('click', function (e) {
        console.log('erehhehre');
        document.querySelectorAll('.room').forEach(function (roomButton) {
            roomButton.classList.contains('collapse') ? roomButton.classList.remove('collapse') : roomButton.classList.add('collapse');
        });
    });
});

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var Store = function Store() {
    this.handle = '';
    this.room = 'general';
    this.store = {};
    this.rooms = {};
    this.userList = {};
    this.msgs = [];
    this.setRoom = this.setRoom.bind(this);
    this.roomName = this.roomName.bind(this);
};
Store.prototype.roomName = function () {
    return this.room;
};
Store.prototype.setRoom = function (room) {
    this.room = room;
    document.getElementById('roomname').innerHTML = '<h1>' + store.roomName() + '</h1>';
};

Store.prototype.changeUserlist = function (rooms, userList) {
    this.userList = userList;
    this.rooms = rooms;
    var userListEl = document.getElementById('userList');
    userListEl.innerHTML = '';

    var roomChangeInput = document.getElementById('roomChangeInput');
    var roomChangeButton = document.getElementById('roomChangeButton');

    Object.keys(this.rooms).forEach(function (room, i) {

        var roomEl = document.createElement('li');
        roomEl.innerHTML = '<div><button id=roomButton-' + i + ' data-room=' + room + '>' + room + '</button><button data-room=' + room + ' id=\'collapseRoom\'>[x]</button</div>';
        roomEl.classList.add('room');
        roomEl.querySelector('#collapseRoom').addEventListener('click', function (e) {
            roomEl.classList.contains('collapse') ? roomEl.classList.remove('collapse') : roomEl.classList.add('collapse');
        });
        var roomElList = document.createElement('ul');
        roomElList.classList.add('roomUserList');

        roomEl.appendChild(roomElList);
        userListEl.appendChild(roomEl);

        rooms[room].forEach(function (user) {
            console.log('userlist', typeof user === 'undefined' ? 'undefined' : _typeof(user), user);
            var li = document.createElement('li');
            li.innerHTML = '<button id=\'userButton\' data-name=' + user.name + '\'>' + user.name + '</button>';
            roomElList.appendChild(li);
        });

        document.querySelectorAll('#roomButton').forEach(function (button) {
            button.addEventListener('click', function (e) {
                console.log(button.dataset.room);
                roomChangeInput.value = button.dataset.room;
                roomChangeButton.click();
            });
        });

        document.querySelectorAll('#userButton').forEach(function (button) {
            button.addEventListener('click', function (e) {
                console.log(button.dataset.name);
            });
        });
    });
};

var store = new Store();
exports.default = store;

/***/ }),
/* 2 */
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
        // console.log('received:',msg);
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

/***/ })
/******/ ]);
//# sourceMappingURL=bundle.js.map