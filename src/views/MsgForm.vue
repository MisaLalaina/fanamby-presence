<template>
    <div class="container">
      <h2>Envoi SMS – Akademia Fanamby</h2>
      
      <p v-if="status">{{ status }}</p>

      <form @submit.prevent="onSubmit">
        <div>
          <label for="phone">Téléphone :</label>
          <input
            id="phone"
            v-model="phone"
            placeholder="+261000000000"
            required
          />
        </div>
  
        <div>
          <label for="presenceDate">Date de présence :</label>
          <input
            id="presenceDate"
            type="date"
            v-model="presenceDate"
            required
          />
        </div>
  
        <div>
          <label for="content">Message :</label>
          <textarea
            id="content"
            v-model="content"
            placeholder="Exemple : Votre enfant doit être présent à..."
            required
          ></textarea>
        </div>
  
        <button type="submit">Envoyer</button>
      </form>
    </div>
  </template>
  
  <script>
  import { sendSMS } from "../services/msg-sender.js";
  
  export default {
    name: "MsgForm",
    data() {
      return {
        phone: "",
        presenceDate: "",
        content: "",
        status: "",
      };
    },
    methods: {
      async onSubmit() {
        this.status = "Envoi en cours...";
        try {
          const res = await sendSMS(
            this.phone,
            this.presenceDate,
            this.content
          );
          console.log("API Response:", res);
          this.status = "SMS envoyé avec succès !";
        } catch (err) {
          console.error(err);
          this.status = "Erreur: " + err.message;
        }
      },
    },
  };
  </script>

<style scoped>
  .container {
    max-width: 500px;
    margin: 2rem auto;
    padding: 2rem;
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  
  h2 {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 1.8rem;
    font-weight: 600;
    font-size: 1.8rem;
    position: relative;
    padding-bottom: 0.5rem;
  }
  
  /* h2::after { */
    /* content: '';
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 60px;
    height: 3px; */
    /* background: linear-gradient(to right, #42b883, #2c8f6e); */
    /* border-radius: 3px; */
  /* } */
  
  form div {
    margin-bottom: 1.5rem;
    position: relative;
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #34495e;
    font-size: 0.95rem;
  }
  
  input, textarea {
    width: 100%;
    padding: 0.85rem 1rem;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
    box-sizing: border-box;
    font-family: inherit;
  }
  
  /* input:focus, textarea:focus {
    outline: none;
    border-color: #42b883;
    box-shadow: 0 0 0 3px rgba(66, 184, 131, 0.2);
  } */
  
  textarea {
    min-height: 120px;
    resize: vertical;
  }
  
  button {
    background: #2A88C8;
    color: white;
    padding: 0.85rem 1.5rem;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 1rem;
    font-weight: 600;
    width: 100%;
    transition: all 0.3s ease;
    box-shadow: 0 4px 6px rgba(44, 143, 110, 0.2);
  }
  
  button:hover {
    background: linear-gradient(to right, #3aa876, #267a5d);
    transform: translateY(-2px);
    box-shadow: 0 6px 8px rgba(44, 143, 110, 0.3);
  }
  
  button:active {
    transform: translateY(0);
  }
  
  p {
    text-align: center;
    padding: 0.75rem;
    border-radius: 6px;
    margin-top: 1.5rem;
    font-weight: 500;
  }
  
  /* Style pour le statut de succès */
  p[v-if="status"] {
    background-color: #e8f5e9;
    color: #2e7d32;
    border: 1px solid #a5d6a7;
  }
  
  /* Style pour le statut d'erreur */
  p[v-if="status"]:contains("Erreur") {
    background-color: #ffebee;
    color: #c62828;
    border: 1px solid #ef9a9a;
  }
  
  /* Animation pour le statut */
  p[v-if="status"] {
    animation: fadeIn 0.5s ease;
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  /* Responsive design */
  @media (max-width: 576px) {
    .container {
      margin: 1rem;
      padding: 1.5rem;
    }
    
    h2 {
      font-size: 1.5rem;
    }
    
    input, textarea, button {
      padding: 0.75rem;
    }
  }
</style>