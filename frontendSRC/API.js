
// var payloadd = {
//     username: 'timlkjkh',
//     password: 'passsssssss'
// };

export const login = (payload)=>fetch("http://localhost:3000/api/login",
        {
            method: "POST",
            body: JSON.stringify(payload),
        })
        .then((res)=>res.json().then((data)=>{
            if (res.ok){
                return data
            }else{
                throw new Error(data.error);
            }
        }));

export const signup = (payload) => fetch("http://localhost:3000/api/signup",
    {
        method: "POST",
        body: JSON.stringify(payload),
    })
    .then((res) => res.json().then((data) => {
        if (res.ok) {
            return data
        } else {
            throw new Error(data.error);
        }
    }));

export const guest = () => fetch("http://localhost:3000/api/login",
    {
        method: "POST",
        body: JSON.stringify({'username':'guest','password':'password'}),
    })
    .then((res) => res.json().then((data) => {
        if (res.ok) {
            return data
        } else {
            throw new Error(data.error);
        }
    }));
export const isUser = (payload) => fetch("http://localhost:3000/api/isuser",
    {
        method: "POST",
        body: JSON.stringify(payload),
    })
    .then((res)=> res.json())

const auth = ()=> fetch("http://localhost:3000/api/login",
    {
        method: "POST",
        body: JSON.stringify(payload),
    //auth headers  //  // headers: new Headers({ 'authentication': 'jwt start' })
    })
    .then(function (res) { return res.json(); })
    .then(function (data) { console.log(JSON.stringify(data)) })


