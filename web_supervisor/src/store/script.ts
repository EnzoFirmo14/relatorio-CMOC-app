import { auth } from "./firebase.js";

import {
    createUserWithEmailAndPassword,
    signInWithEmailAndPassword,
    signOut
} from "https://www.gstatic.com/firebasejs/12.0.0/firebase-auth.js";

const btnCadastrar = document.getElementById("cadastrar");

btnCadastrar.addEventListener("click", () => {

    const email = document.getElementById("email").value;
    const senha = document.getElementById("senha").value;

    createUserWithEmailAndPassword(auth, email, senha)
        .then((userCredential) => {
            alert("Usuário cadastrado com sucesso!");
        })
        .catch((error) => {
            alert(error.message);
        });

});