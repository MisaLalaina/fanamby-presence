<template>
  <div class="login-club">
    <h1>Conectez-vous</h1>

    <div class="input-group">
      <label for="name">Nom d'utilisateur</label>
      <input
        type="text"
        id="name"
        v-model="nom"
        required
        placeholder="Entrez votre nom"
      />
    </div>

    <div class="input-group">
      <label for="password">Mot de passe</label>
      <input
        type="password"
        id="password"
        v-model="password"
        required
        placeholder="Entrez votre mot de passe"
      />
    </div>

    <button @click="seConnecter">Se connecter</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      nom: '',
      password: ''
    }
  },
  methods: {
    seConnecter() {
      // Logique de connexion ici
      alert(`Nom: ${this.nom}, Mot de passe: ${this.password}`);
    }
  }
}
</script>

<style scoped>
.login-club {
  max-width: 400px;
  margin: 80px auto;
  padding: 50px;
  background-color: #ffffff;
  border-radius: 5px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  font-family: Arial, sans-serif;
  text-align: center;
}

h1 {
  margin-bottom: 30px;
  color: #164773;
}

.input-group {
  margin-bottom: 30px;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 6px;
  font-weight: bold;
  color: #555;
}

input {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s;
}

input:focus {
  border-color: #62c5ec;
  outline: none;
}

button {
  width: 108%;
  padding: 12px;
  background-color: #2493BF;
  border: none;
  border-radius: 6px;
  color: white;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #2493BF;
}
</style>
