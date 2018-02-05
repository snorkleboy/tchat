import store from './store';
import WSmaker from './WS';


document.addEventListener('DOMContentLoaded', () => {

    const signinSubmit = document.getElementById('signin-submit');
    const handlein = document.getElementById('handle-Signin');
    const appholder = document.getElementById('appholder');
    const signin = document.getElementById('signin');

    signinSubmit.addEventListener('click', () => {
        console.log(handlein.value);
        WSmaker(handlein.value.length > 1 ? handlein.value : 'anon', store);
        appholder.classList.remove('blur');
        signin.style.display = 'none';
    })
});


