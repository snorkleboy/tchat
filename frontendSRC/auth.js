
import WSmaker from './WS';
import { login, signup, isUser } from './API'

const diffUserButton = document.createElement('input')

const authSeq = function(){
    this.passwordSetup = this.passwordSetup.bind(this);
    this.changeToLogin = this.changeToLogin.bind(this);
    this.changeToSignUp = this.changeToSignUp.bind(this);
}
authSeq.prototype.passwordSetup = function(handle,store){
    isUser({"username":handle}).then((res) => {
        console.log("THISTHITSTHTITHIS", this);
        const signinButtons = document.getElementById('signin-buttons');
        const anotherUserButton = document.createElement('INPUT');
        anotherUserButton.type='submit';
        anotherUserButton.value='Another User';
        anotherUserButton.id='anotherUserButton';
        anotherUserButton.addEventListener('click', this.signInInitialHandleMaker(store))
        
        let a = signinButtons.appendChild(anotherUserButton);
        console.log(signinButtons, anotherUserButton,a.parentElement);
        console.log('registered:', res.isuser);
        if (res.isuser) {
            this.changeToLogin(handle, store)
        } else {
            this.changeToSignUp(handle, store);
        }
    })

}

authSeq.prototype.finalize = function(handle,store){
    store.setHandle(handle.length > 1 ? handle : 'anon');
    store.signedIn = true;
    WSmaker(store);
    appholder.classList.remove('blur');
    signin.style.display = 'none';
    const signinSubmit = document.getElementById('signin-submit');
    signinSubmit.parentElement.removeChild(signinSubmit);
}
authSeq.prototype.changeToSignUp = function(handle,store){
    const input = document.getElementById('handle-Signin');
    input.placeholder= 'enter Password';

    const signin = document.getElementById('signin');
    const text = signin.querySelector('h1')
    text.innerText = `-${handle}- not registered, enter a password to create an account or press guest`

    const signinSubmit = document.getElementById('signin-submit');
    signinSubmit.addEventListener('click',()=>{
        console.log("signing", input.value)
        signup({ username: handle, password: input.value }).then((res)=>{
            console.log(res)
            this.finalize(handle,store);
        });
    });

}
authSeq.prototype.changeToLogin = function(handle,store){
    console.log("EHERHEHERHRHERHRHEH",this)
    const input = document.getElementById('handle-Signin');
    input.placeholder = 'enter Password';

    const signin = document.getElementById('signin');
    const text = signin.querySelector('h1')
    text.innerText = `welcome back, -${handle}- , please enter password`

    const signinSubmit = document.getElementById('signin-submit');
    signinSubmit.addEventListener('click', () => {
        console.log("login", input.value)
        login({ username: handle, password: input.value }).then((res)=>{
            console.log(res);
            this.finalize(handle,store);
        });
    });

}
authSeq.prototype.signInInitialHandleMaker = function(store){
    return ()=>{
        const anotherUserButton = document.getElementById('anotherUserButton');
        anotherUserButton.parentElement.removeChild(anotherUserButton);

        let signinSubmit = document.getElementById('signin-submit');
        const clone = signinSubmit.cloneNode();
        signinSubmit.parentElement.replaceChild(clone,signinSubmit);
        signinSubmit = clone;
        const handlein = document.getElementById('handle-Signin');
        handlein.focus();
        const appholder = document.getElementById('appholder');
        const signin = document.getElementById('signin');
        let signedIn = false;

        const input = document.getElementById('handle-Signin');
        input.placeholder = 'enter username';
        const text = signin.querySelector('h1')
        text.innerText = `Welcome To Chat, please enter a name or press guest`




        const signinClickHandle = () => {
            console.log('login attempt', handlein.value);
            let handle = handlein.value.replace(/\s+/g, '');
            console.log(authseq);
            handlein.value = ''
            authseq.passwordSetup(handle, store);
            signinSubmit.removeEventListener('click', signinClickHandle);



        };
        signinSubmit.addEventListener('click', signinClickHandle)
    }
}
const authseq = new authSeq();
export default authseq;