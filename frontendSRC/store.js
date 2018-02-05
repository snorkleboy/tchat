const Store = function(){
    this.handle = ''
    this.store = {};
    this.rooms = {};
    this.userList={}
    this.msgs = [];
} 
Store.prototype.changeUserlist = function(rooms,userList){
    this.userList = userList;
    this.rooms=rooms;
    const userListEl = document.getElementById('userList');
    userListEl.innerHTML=''
    Object.keys(this.rooms).forEach((room)=>{
        const roomEl = document.createElement('li');
        const roomElList = document.createElement('ul');
        roomEl.innerHTML=`<h1>${room}</h1>`
        roomEl.appendChild(roomElList);
        userListEl.appendChild(roomEl)
        rooms[room].forEach((user)=>{
            console.log('userlist', typeof (user), user);
            const li = document.createElement('li');
            li.innerHTML = `<h1>${user.name}</h1>`
            roomElList.appendChild(li);
        })
        
    })

}
const store = new Store()
export default store;
