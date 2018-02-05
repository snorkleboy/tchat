import store from './store';
import WSmaker from './WS';


document.addEventListener('DOMContentLoaded', () => {

    const signinSubmit = document.getElementById('signin-submit');
    const handlein = document.getElementById('handle-Signin');
    const appholder = document.getElementById('appholder');
    const signin = document.getElementById('signin');
    let signedIn = false;
    //one time event
    //binds enter to signin button then unbinds it (it gets rebound to submit messages)
    const signInEnter = function (e){
        if (e.key == 'Enter' && !signedIn) {
            const signinSubmitel = document.getElementById('signin-submit');
            signinSubmitel.click();
            document.removeEventListener('keypress', signInEnter);
        }
    }
    document.addEventListener('keypress', signInEnter);

    //sets name in store and intializes websocket connection
    signinSubmit.addEventListener('click', () => {
        signedIn = true;
        store.handle = handlein.value.length > 1 ? handlein.value : 'anon';
        WSmaker(store);
        appholder.classList.remove('blur');
        signin.style.display = 'none';
    })
});


