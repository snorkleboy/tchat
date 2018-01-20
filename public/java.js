document.addEventListener('DOMContentLoaded',()=>{
    console.log('loaded');
    const subBtn = document.getElementById('submit');
    const input = document.getElementById('chatin');

    subBtn.addEventListener('click',(e)=>{
        e.preventDefault();
        console.log('submit clicked');
        console.log(e);
        console.log(input.value)
    })
});