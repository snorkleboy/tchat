export const login = (payload) => fetch("api/login", {
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

export const signup = (payload) => fetch("api/signup", {
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

export const guest = () => fetch("api/login", {
        method: "POST",
        body: JSON.stringify({
            'username': 'guest',
            'password': 'password'
        }),
    })
    .then((res) => res.json().then((data) => {
        if (res.ok) {
            return data
        } else {
            throw new Error(data.error);
        }
    }));
export const isUser = (payload) => fetch("api/isuser", {
        method: "POST",
        body: JSON.stringify(payload),
    })
    .then((res) => res.json())

const auth = () => fetch("api/login", {
        method: "POST",
        body: JSON.stringify(payload),
        //auth headers  //  // headers: new Headers({ 'authentication': 'jwt start' })
    })
    .then(function (res) {
        return res.json();
    })
    .then(function (data) {
        console.log(JSON.stringify(data))
    })