

const WSmaker = (store,token) =>{
    // console.log('loaded');
    const subBtn = document.getElementById('submit');
    const handle = store.handle;
    const input = document.getElementById('chatin');
    input.focus();
    const messageBox = document.getElementById('messageBox');

    const roomChangeInput = document.getElementById('roomChangeInput');
    const roomChangeButton = document.getElementById('roomChangeButton')

    const scheme = "ws://";
    const uri = scheme + window.document.location.host + "/" + handle + '/' + token;
    const ws = new WebSocket(uri);

    ws.onmessage = (msg)=>{
        const data = JSON.parse(msg.data);
        if (data.action === 'msg'){
            const msgEl = document.createElement('li');
            msgEl.innerHTML = `
        <h1>${data.handle}: ${data.text}</h1>
        `;
            messageBox.appendChild(msgEl);
            bottomizeScroll();
        }else{
            console.log('RECEIVED WS COMMAND',data.action,data.payload,data)
            controller(data,store)
        }
        
    };

    ws.onerror = (err) =>{
         console.log('web socket error',err);
    };

    ws.onclose = (e) =>{
         console.log('websocket closing',e);
    };

    ws.onopen = (e) =>{
    };

    // send message
    subBtn.addEventListener('click',(e)=>{
        
        e.preventDefault();
        const text = input.value;

        console.log('submit clicked', handle, text);

        ws.send(JSON.stringify({
            action:'msg',
            room:store.roomName(),
            handle:handle,
            text:text
        }));

        const msgEl = document.createElement('li');
        msgEl.innerHTML = `
        <h1>${handle}: ${text}</h1>
        `;
        msgEl.classList.add('myMessage')
        messageBox.appendChild(msgEl);
        bottomizeScroll();


        input.value="";
        input.select();
    });
    //send message by pressing enter
    document.addEventListener('keypress', (e) => {
        if (e.key == 'Enter') {
            subBtn.click();
        }
    });

    //change rooms
    roomChangeButton.addEventListener('click',(e)=>{
        store.setRoom(roomChangeInput.value);
        roomChangeInput.value = ''
        ws.send(JSON.stringify({
            action: 'roomChange',
            payload:{
                room: store.room
            }
        }));

    })

};
function controller(data,store){
    switch (data.action) {
        case "userList":
            store.changeUserlist(data.payload.rooms, data.payload.userList);
            break;
        case 'error':
            store.setError(data.payload.error);
            break;
        default:
            console.log('unknown action', data)
    }

}
function bottomizeScroll() {
    var element = document.getElementById("messages");
    element.scrollTop = element.scrollHeight;
}

export default WSmaker;