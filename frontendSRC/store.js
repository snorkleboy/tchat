
import UI from './ui';
const Store = function(){
    this.ui = new UI(this);
    this.handle = ''
    this.room = 'general'
    this.signedIn = false;
    this.store = {};
    this.rooms = {};
    this.userList={}
    this.msgs = [];
    this.setRoom = this.setRoom.bind(this);


} 


Store.prototype.setHandle = function(handle){
    this.handle = handle
    this.ui.makeName(handle);

}
Store.prototype.setRoom = function(room){
    this.room = room;
    this.ui.makeRoom(room);
}
Store.prototype.changeUserlist = function(rooms,userList){
    this.userList = userList;
    this.rooms=rooms;
    this.ui.makeUserList(rooms);
}



export default Store;
