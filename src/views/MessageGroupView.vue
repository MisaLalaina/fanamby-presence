<script>
import { feed } from '@/services/facebookService';
import { sendMessageGroupBySMS } from '@/services/msg-sender';

export default {
  name: "SendMessage",
  data() {
    return {
      message: "",
      sendFacebook: false,
      sendSMS: false,
      phoneNumbers: [
        { number: "+261388155970", selected: true },
        { number: "+261384178406", selected: true },
      ],
      status: "",
      maxlength:100
    };
  },
  methods: {
    async submitForm() {
      this.status = "Envoi en cours...";

      // Collecte les numéros sélectionnés
      const selectedNumbers = this.phoneNumbers
        .filter(p => p.selected)
        .map(p => p.number);

      console.log("Message :", this.message);
      console.log("Facebook :", this.sendFacebook);
      console.log("SMS :", this.sendSMS);
      console.log("Numéros sélectionnés :", selectedNumbers);


      if (this.sendSMS) {
        const smsResponses = sendMessageGroupBySMS(selectedNumbers,this.message)
      }
      if (this.sendFacebook) {
        const fbResponse = await feed(this.message)
      }

      // Simule l'envoi
      setTimeout(() => {
        this.status = "Message envoyé avec succès !";
      }, 1000);
    },
  },
  computed: {
    contentLength() {
      return this.message.length
    }
  }
};
</script>

<template>
  <div class="container">
    <h2>Envoi de message et publication</h2>

    <p v-if="status">{{ status }}</p>

    <form @submit.prevent="submitForm">
      <!-- Champ message -->
      <div>
        <label for="message"> Message :</label>
        <textarea
          id="message"
          v-model="message"
          placeholder="Votre message ici..."
          required
          minlength="0"
          :maxlength="maxlength"
        ></textarea>
        <p>{{ contentLength }} / {{ maxlength }}</p>
      </div>

      <!-- Choix canaux -->
      <div class="channels">
        <label>
          <input type="checkbox" v-model="sendFacebook" />
          Facebook
        </label>

        <label>
          <input type="checkbox" v-model="sendSMS" />
          SMS
        </label>
      </div>

      <!-- Liste numéros si SMS est coché -->
      <div v-if="sendSMS" class="numbers-list">
        <h4>Choisissez les numéros :</h4>
        <div
          v-for="(phone, index) in phoneNumbers"
          :key="index"
          class="phone-item"
        >
          <label>
            <input type="checkbox" v-model="phone.selected" />
            {{ phone.number }}
          </label>
        </div>
      </div>

      <button type="submit">Envoyer</button>
    </form>
  </div>
</template>

<style scoped>
.container {
  max-width: 500px;
  margin: 2rem auto;
  padding: 2rem;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 25px rgba(178, 185, 185, 0.1);
}

h2 {
  text-align: center;
  color: #3498db;
  margin-bottom: 1.8rem;
  font-weight: 600;
  font-size: 1.8rem;
}

form div {
  margin-bottom: 1.5rem;
}

label {
  font-size: 0.95rem;
  color: #555;
}

textarea {
  width: 100%;
  padding: 0.85rem 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  min-height: 120px;
  resize: vertical;
  font-size: 1rem;
}

.channels {
  display: flex;
  gap: 1.5rem;
}

.numbers-list {
  padding: 1rem;
  border: 1px solid #eee;
  border-radius: 8px;
  background: #f9f9f9;
}

.phone-item {
  margin-bottom: 0.5rem;
}

button {
  background: #2a88c8;
  color: white;
  padding: 0.85rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
  width: 100%;
}

button:hover {
  transform: translateY(-2px);
}

p {
  text-align: center;
  padding: 0.75rem;
  border-radius: 6px;
  margin-top: 1.5rem;
  font-weight: 500;
  color: #2e7d32;
}
</style>
