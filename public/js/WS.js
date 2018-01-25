document.addEventListener('DOMContentLoaded',()=>{
    // console.log('loaded');
    window.chat = {};
    window.chat.name = 'anon';
    const subBtn = document.getElementById('submit');
    const chat = window.chat;
    const input = document.getElementById('chatin');
    const messageBox = document.getElementById('messageBox');

    const scheme = "ws://";
    const uri = scheme + window.document.location.host + "/";
    const ws = new WebSocket(uri);

    // console.log(ws);
    // console.log(uri);
    ws.onmessage = (msg)=>{
        // console.log('received:',msg);
        const data = JSON.parse(msg.data);
        const msgEl = document.createElement('li');
        msgEl.innerHTML = `
        <h1>${data.handle}: ${data.text}</h1>
        `;
        messageBox.appendChild(msgEl);
        bottomizeScroll();
        
    };

    ws.onerror = (err) =>{
        // console.log('web socket error',err);
    };

    ws.onclose = (e) =>{
        // console.log('websocket closing',e);
    };

    ws.onopen = (e) =>{
        // console.log('websocket opening',e);
    };

    subBtn.addEventListener('click',(e)=>{
        
        e.preventDefault();
        const handle = chat.name;
        const text = input.value;

        console.log('submit clicked', handle, text);

        ws.send(JSON.stringify({
            room:0,
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
    document.addEventListener('keypress', (e) => {
        if (e.key == 'Enter') {
            subBtn.click();
        }
    });

});

function bottomizeScroll() {
    var element = document.getElementById("messages");
    element.scrollTop = element.scrollHeight;
}