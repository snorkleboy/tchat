
document.addEventListener('DOMContentLoaded', () => {

    const signinSubmit = document.getElementById('signin-submit');
    const handlein = document.getElementById('handle-Signin');
    const appholder = document.getElementById('appholder');
    const signin = document.getElementById('signin');


    signinSubmit.addEventListener('click',()=>{
        console.log(handlein.value);
        window.chat.name = handlein.value.length >1 ? handlein.value : 'anon'
        appholder.classList.remove('blur');
        signin.style.display = 'none';
    })
});


