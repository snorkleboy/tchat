class UI{
    constructor(store){
        this.store = store;

        //makes room list collapseable on each room
        document.getElementById('userlistLabel').addEventListener('click', (e) => {
            document.querySelectorAll('.room').forEach((roomButton) => {
                roomButton.classList.contains('collapse') ? roomButton.classList.remove('collapse') : roomButton.classList.add('collapse');
            })
        })


        //binds enter to signinbutton at start
        const signInEnter = function (e) {
            if (!store.signedIn && e.key == 'Enter') {
                const signinSubmitel = document.getElementById('signin-submit');
                signinSubmitel.click();
            }else if(store.signedIn){
                document.removeEventListener('keypress',signInEnter);
            }
        }
        document.addEventListener('keypress', signInEnter);
    }

    makeName(handle){
        const username = document.getElementById('username');
        username.innerHTML = `<h1>${handle}</h1>`
    }
    makeRoom(roomName){
        const roomname = document.getElementById('roomname')
        document.getElementById('roomname').innerHTML = `<h1>${roomName}</h1>`
    }
    makeUserList(rooms){
        const userListEl = document.getElementById('userList');
        userListEl.innerHTML = ''

        const roomChangeInput = document.getElementById('roomChangeInput');
        const roomChangeButton = document.getElementById('roomChangeButton')

        Object.keys(rooms).forEach((room, i) => {


            const roomEl = document.createElement('li');
            roomEl.innerHTML = `<div><button id=roomButton data-room=${room}>${room}</button><button data-room=${room} id='collapseRoom'>[x]</button</div>`
            roomEl.classList.add('room')
            roomEl.querySelector('#collapseRoom').addEventListener('click', (e) => {
                roomEl.classList.contains('collapse') ? roomEl.classList.remove('collapse') : roomEl.classList.add('collapse');
            })
            const roomElList = document.createElement('ul');
            roomElList.classList.add('roomUserList')

            roomEl.appendChild(roomElList);
            userListEl.appendChild(roomEl)

            rooms[room].forEach((user) => {
                console.log('userlist', typeof (user), user);
                const li = document.createElement('li');
                li.innerHTML = `<button id='userButton' data-name=${user.name}'>${user.name}</button>`
                roomElList.appendChild(li);
            })

            document.querySelectorAll('#roomButton').forEach((button) => {
                button.addEventListener('click', (e) => {
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
}

export default UI;