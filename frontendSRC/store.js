

const Store = function(){
    this.handle = ''
    this.room = 'general'
    this.signedIn = false;
    this.store = {};
    this.rooms = {};
    this.userList={}
    this.msgs = [];
    this.setRoom = this.setRoom.bind(this);
    this.roomName = this.roomName.bind(this);
} 


Store.prototype.setHandle = function(handle){

    const username = document.getElementById('username');
    this.handle = handle
    username.innerHTML = `<h1>${this.handle}</h1>`
}
Store.prototype.roomName = function(){
    return this.room
}
Store.prototype.setRoom = function(room){
    const roomname = document.getElementById('roomname')
    this.room = room;
    document.getElementById('roomname').innerHTML = `<h1>${this.roomName()}</h1>`
}


Store.prototype.changeUserlist = function(rooms,userList){
    this.userList = userList;
    this.rooms=rooms;
    const userListEl = document.getElementById('userList');
    userListEl.innerHTML=''

    const roomChangeInput = document.getElementById('roomChangeInput');
    const roomChangeButton = document.getElementById('roomChangeButton')

    Object.keys(this.rooms).forEach((room,i)=>{


        const roomEl = document.createElement('li');
        roomEl.innerHTML = `<div><button id=roomButton data-room=${room}>${room}</button><button data-room=${room} id='collapseRoom'>[x]</button</div>`
        roomEl.classList.add('room')
        roomEl.querySelector('#collapseRoom').addEventListener('click',(e)=>{
            roomEl.classList.contains('collapse') ? roomEl.classList.remove('collapse') : roomEl.classList.add('collapse');
        })
        const roomElList = document.createElement('ul');
        roomElList.classList.add('roomUserList')
        
        roomEl.appendChild(roomElList);
        userListEl.appendChild(roomEl)

        rooms[room].forEach((user)=>{
            console.log('userlist', typeof (user), user);
            const li = document.createElement('li');
            li.innerHTML = `<button id='userButton' data-name=${user.name}'>${user.name}</button>`
            roomElList.appendChild(li);
        })
        
        document.querySelectorAll('#roomButton').forEach((button)=>{
            button.addEventListener('click',(e)=>{
                console.log(button.dataset.room)
                roomChangeInput.value = button.dataset.room
                roomChangeButton.click();
            })
        })

        document.querySelectorAll('#userButton').forEach((button) => {
            button.addEventListener('click', (e) => {
                console.log(button.dataset.name)
            })
        })

    })

}


const store = new Store()
export default store;
