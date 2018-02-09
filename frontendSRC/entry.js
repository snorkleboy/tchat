import store from './store';
// import WSmaker from './WS';
import {login,signup,isUser} from './API'
import {authSeq} from './auth';


const startup = () => {

    const signinSubmit = document.getElementById('signin-submit');
    const handlein = document.getElementById('handle-Signin');
    handlein.focus();
    const appholder = document.getElementById('appholder');
    const signin = document.getElementById('signin');
    let signedIn = false;

    //one time event
    //binds enter to signin button then unbinds it (it gets rebound to submit messages)
    
    const signInEnter = function (e){
        if (e.key == 'Enter') {
            const signinSubmitel = document.getElementById('signin-submit');
            signinSubmitel.click();
            
        }
    }
    document.addEventListener('keypress', signInEnter);

    //sets name in store and intializes websocket connection
    
    const signinClickHandle = () => {
        document.removeEventListener('keypress', signInEnter);
        console.log('login attempt',handlein.value);
        let handle = handlein.value.replace(/\s+/g, '');
        console.log(authSeq);
        handlein.value = ''
        authSeq(handle,store);
        signinSubmit.removeEventListener('click', signinClickHandle);
        

        
    };
    signinSubmit.addEventListener('click', signinClickHandle)

    document.getElementById('userlistLabel').addEventListener('click',(e)=>{
        document.querySelectorAll('.room').forEach((roomButton)=>{
            roomButton.classList.contains('collapse') ? roomButton.classList.remove('collapse') : roomButton.classList.add('collapse');
        })  
    })

};

document.addEventListener('DOMContentLoaded', startup);

