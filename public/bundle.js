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
    var appholder = document.getElementById('appholder');
    var signin = document.getElementById('signin');

    signinSubmit.addEventListener('click', function () {
        console.log(handlein.value);
        (0, _WS2.default)(handlein.value.length > 1 ? handlein.value : 'anon', _store2.default);
        appholder.classList.remove('blur');
        signin.style.display = 'none';
    });
});

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});
var Store = function Store() {
    this.store = {};
    this.userList = {};
    this.rooms = {};
    this.msgs = [];
};
Store.prototype.changeUserlist = function (userlist) {
    var userList = document.getElementById('userList');
    userlist.forEach(function (user) {
        console.log('userlist', user);
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


var WSmaker = function WSmaker(clientName, store) {
    // console.log('loaded');
    var subBtn = document.getElementById('submit');
    var chat = clientName;
    var input = document.getElementById('chatin');
    var messageBox = document.getElementById('messageBox');

    var scheme = "ws://";
    var uri = scheme + window.document.location.host + "/" + chat;
    var ws = new WebSocket(uri);

    // console.log(ws);
    // console.log(uri);
    ws.onmessage = function (msg) {
        // console.log('received:',msg);
        var data = JSON.parse(msg.data);
        if (data.action === 'msg') {
            var msgEl = document.createElement('li');
            msgEl.innerHTML = '\n        <h1>' + data.handle + ': ' + data.text + '</h1>\n        ';
            messageBox.appendChild(msgEl);
            bottomizeScroll();
        } else {
            console.log('RECEIVED WS COMMAND', data);
            switch (data.action) {
                case 'userList':
                    store.changeUserlist(data.payload);
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

    ws.onopen = function (e) {
        ws.send(JSON.stringify({
            'action': 'newUser',
            'payload': { 'name': chat, 'room': 'general' }
        }));
    };

    subBtn.addEventListener('click', function (e) {

        e.preventDefault();
        var handle = chat.name;
        var text = input.value;

        console.log('submit clicked', handle, text);

        ws.send(JSON.stringify({
            action: 'msg',
            room: 'general',
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
    document.addEventListener('keypress', function (e) {
        if (e.key == 'Enter') {
            subBtn.click();
        }
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