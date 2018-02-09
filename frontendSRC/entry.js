import Store from './store';
import WSmaker from './WS';
import {login,signup,isUser,guest} from './API'
import authSeq from './auth';


const startup = () => {
    const store = new Store();
    const signinSubmit = document.getElementById('signin-submit');
    const handlein = document.getElementById('handle-Signin');
    handlein.focus();
    const appholder = document.getElementById('appholder');
    const signin = document.getElementById('signin');
    const guestSignIn = document.getElementById('signin-guest')


    const signInEnter = function (e){
        if (!store.signedIn && e.key == 'Enter') {
            const signinSubmitel = document.getElementById('signin-submit');
            signinSubmitel.click();
            
        }
    }
    document.addEventListener('keypress', signInEnter);

    
    const signinClickHandle = () => {
        console.log('login attempt',handlein.value);
        let handle = handlein.value.replace(/\s+/g, '');
        console.log(authSeq);
        handlein.value = ''
        authSeq.passwordSetup(handle,store);
        signinSubmit.removeEventListener('click', signinClickHandle);
    };
    signinSubmit.addEventListener('click', signinClickHandle)



    guestSignIn.addEventListener('click',()=>{
        guest().then((res)=>{
            signinSubmit.removeEventListener('click', signinClickHandle);
            document.removeEventListener('keypress', signInEnter);
            console.log(res)
            authSeq.finalize('guest',store);
        });

    })
};

document.addEventListener('DOMContentLoaded', startup);

