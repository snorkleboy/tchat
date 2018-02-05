const Store = function(){
    this.handle = ''
    this.room = 'general'
    this.store = {};
    this.rooms = {};
    this.userList={}
    this.msgs = [];
    this.roomName = this.roomName.bind(this);
} 
Store.prototype.roomName = function(){
    return this.room
}


Store.prototype.changeUserlist = function(rooms,userList){
    this.userList = userList;
    this.rooms=rooms;
    const userListEl = document.getElementById('userList');
    userListEl.innerHTML=''
    Object.keys(this.rooms).forEach((room)=>{


        const roomEl = document.createElement('li');
        roomEl.innerHTML = `<button id='roomButton' data-room=${room}>${room}</button>`
        roomEl.classList.add('room')

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
