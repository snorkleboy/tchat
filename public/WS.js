document.addEventListener('DOMContentLoaded',()=>{
    console.log('loaded');
    const subBtn = document.getElementById('submit');
    const handleIn = document.getElementById('handle');
    const input = document.getElementById('chatin');
    const messageBox = document.getElementById('messageBox');

    const scheme = "ws://";
    const uri = scheme + window.document.location.host + "/";
    const ws = new WebSocket(uri);

    console.log(ws);
    console.log(uri);
    ws.onmessage = (msg)=>{
        console.log('received:',msg);
        const data = JSON.parse(msg.data);
        const msgEl = document.createElement('li');
        msgEl.innerHTML = `
        <h1>${data.handle}: ${data.text}</h1>
        `;
        messageBox.appendChild(msgEl);
        
    };

    ws.onerror = (err) =>{
        console.log('web socket error',err);
    };

    ws.onclose = (e) =>{
        console.log('websocket closing',e);
    };

    ws.onopen = (e) =>{
        console.log('websocket opening',e);
    };

    subBtn.addEventListener('click',(e)=>{
        
        e.preventDefault();
        const handle = handleIn.value;
        const text = input.value;

        console.log('submit clicked', handle, text);

        ws.send(JSON.stringify({
            room:0,
            handle:handle,
            text:text
        }));
        input.value="";
    });


});