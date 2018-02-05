const Store = function(){
    this.store = {};
    this.userList = {};
    this.rooms = {};
    this.msgs = [];
} 
Store.prototype.changeUserlist = function(userlist){
    const userList = document.getElementById('userList');
    userlist.forEach((user)=>{
        console.log('userlist',user);
    })

}
const store = new Store()
export default store;
