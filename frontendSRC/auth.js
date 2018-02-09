
import WSmaker from './WS';
import { login, signup, isUser } from './API'

const diffUserButton = document.createElement('input')

export const authSeq = function(handle,store){
    isUser({"username":handle}).then((res) => {
        const signinButtons = document.getElementById('signin-buttons');
        const anotherUserButton = document.createElement('INPUT');
        anotherUserButton.type='submit';
        anotherUserButton.value='Another User';
        anotherUserButton.id='anotherUserButton';
        anotherUserButton.addEventListener('click', signInInitialHandleMaker(store))
        
        let a = signinButtons.appendChild(anotherUserButton);
        console.log(signinButtons, anotherUserButton,a.parentElement);
        console.log('registered:', res.isuser);
        if (res.isuser) {
            changeToLogin(handle, store);
            // inform that they will be signing up
            //get password, signup
        } else {
            
            changeToSignUp(handle, store);
            //inform that they will be loggin in
            //get password, try to login

        }
    })




}

const finalize = (handle,store) =>{
    // signedIn = true;
    store.setHandle(handle.length > 1 ? handle : 'anon');

    WSmaker(store);
    appholder.classList.remove('blur');
    signin.style.display = 'none';
}
const changeToSignUp = (handle) => {
    const input = document.getElementById('handle-Signin');
    input.placeholder= 'enter Password';
    const signin = document.getElementById('signin');
    const text = signin.querySelector('h1')
    text.innerText = `-${handle}- not registered, enter a password to create an account or press guest`
    const signinSubmit = document.getElementById('signin-submit');
    signinSubmit.addEventListener('click',()=>{
        console.log("signing", input.value)
    })

}
const changeToLogin = (handle) => {
    const input = document.getElementById('handle-Signin');
    input.placeholder = 'enter Password';
    const signin = document.getElementById('signin');
    const text = signin.querySelector('h1')
    text.innerText = `welcome back, -${handle}- , please enter password`
    const signinSubmit = document.getElementById('signin-submit');
    signinSubmit.addEventListener('click', () => {
        console.log("login", input.value)
    })

}
const signInInitialHandleMaker = (store)=>()=>{
    const anotherUserButton = document.getElementById('anotherUserButton');
    anotherUserButton.parentElement.removeChild(anotherUserButton);

    const signinSubmit = document.getElementById('signin-submit');
    const handlein = document.getElementById('handle-Signin');
    handlein.focus();
    const appholder = document.getElementById('appholder');
    const signin = document.getElementById('signin');
    let signedIn = false;

    const input = document.getElementById('handle-Signin');
    input.placeholder = 'enter username';
    const text = signin.querySelector('h1')
    text.innerText = `Welcome To Chat, please enter a name or press guest`


    const signInEnter = function (e) {
        if (e.key == 'Enter') {
            const signinSubmitel = document.getElementById('signin-submit');
            signinSubmitel.click();

        }
    }
    document.addEventListener('keypress', signInEnter);

    const signinClickHandle = () => {
        document.removeEventListener('keypress', signInEnter);
        console.log('login attempt', handlein.value);
        let handle = handlein.value.replace(/\s+/g, '');
        console.log(authSeq);
        handlein.value = ''
        authSeq(handle, store);
        signinSubmit.removeEventListener('click', signinClickHandle);



    };
    signinSubmit.addEventListener('click', signinClickHandle)
}
