

const WSmaker = (store) =>{
    // console.log('loaded');
    const subBtn = document.getElementById('submit');
    const handle = store.handle;
    const input = document.getElementById('chatin');
    input.focus();
    const messageBox = document.getElementById('messageBox');

    const roomChangeInput = document.getElementById('roomChangeInput');
    const roomChangeButton = document.getElementById('roomChangeButton')

    const scheme = "ws://";
    const uri = scheme + window.document.location.host + "/"+handle;
    const ws = new WebSocket(uri);

    ws.onmessage = (msg)=>{
        // console.log('received:',msg);
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
            switch(data.action){
                case "userList":
                    store.changeUserlist(data.payload.rooms,data.payload.userList);
                    break;
                default:
                    console.log('unknown action',data)
            }
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
            room:'general',
            handle:handle,
            text:text
        }));

        const msgEl = document.createElement('li');
        msgEl.innerHTML = `
        <h1>${handle}: ${text}</h1>
        `;
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
        ws.send(JSON.stringify({
            action: 'roomChange',
            payload:{
                room: roomChangeInput.value
            }
        }));

    })

};

function bottomizeScroll() {
    var element = document.getElementById("messages");
    element.scrollTop = element.scrollHeight;
}

export default WSmaker;