
// var payloadd = {
//     username: 'timlkjkh',
//     password: 'passsssssss'
// };

export const login = (payload)=>fetch("http://localhost:3000/api/login",
        {
            method: "POST",
            body: JSON.stringify(payload),
        })
        .then((res)=>res.json())

export const signup = (payload) => fetch("http://localhost:3000/api/signup",
    {
        method: "POST",
        body: JSON.stringify(payload),
    })
    .then((res) => res.json())
export const isUser = (payload) => fetch("http://localhost:3000/api/isuser",
    {
        method: "POST",
        body: JSON.stringify(payload),
    })
    .then(function (res) { return res.json(); })


const auth = ()=> fetch("http://localhost:3000/api/login",
    {
        method: "POST",
        body: JSON.stringify(payload),
    //auth headers  //  // headers: new Headers({ 'authentication': 'jwt start' })
    })
    .then(function (res) { return res.json(); })
    .then(function (data) { console.log(JSON.stringify(data)) })


