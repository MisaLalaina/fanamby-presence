<script>
import SideBar from '@/components/SideBar.vue';
import { ref } from 'vue';
import { createJoueur } from '@/services/JoueurService';

export default {
  name: 'FormulaireJoueur',
  components: { SideBar },
  setup() {
    const joueur = ref({
      idclubClub: { 
        idclub: 1,
        nomclub: "Fanamby Madagascar",
        ville: "Antananarivo",
        datecreation: "2020-05-15",
        couleurs: "Bleu et Blanc",
        logo: "",
        email: "contact@fanamby-madagascar.mg",
        motdepasse: "",
        telephone: "+261 34 12 345 67",
        adresse: "Lot II M 47 Bis Ambatobe",
        president: "Jean Rakotomalala",
        datefondation: 2020,
        stadeprincipal: "Stade Municipal de Mahamasina",
        siteweb: ""
      },
      idpostePoste: { 
        idposte: 1,
        libelle: "Attaquant",
        description: "Joueur offensif" 
      },
      idstatutjoueurStatutjoueur: { 
        idstatutjoueur: 1,
        libelle: "Actif",
        peutjouer: true 
      },
      idpiedfortPiedfort: { 
        idpiedfort: 1,
        libelle: "Droit" 
      },
      nom: '',
      prenom: '',
      datenaissance: '',
      lieunaissance: 'Antananarivo',
      nationalite: 'Malagasy',
      taille: 0,
      poids: 0,
      photo: '',
      numeromaillot: 0,
      telephone: '',
      email: '',
      nompere: '',
      nommere: '',
      telparent: '',
      certificatmedical: '',
      datevaliditecertificat: '',
      numerolicence: '',
      dateinscription: new Date().toISOString().slice(0, 10),
      adresse: '',
      contact: ''
    });

    const calculerAge = () => {
      if (joueur.value.datenaissance) {
        const today = new Date();
        const birthDate = new Date(joueur.value.datenaissance);
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
          age--;
        }
        
        joueur.value.age = age;
      } else {
        joueur.value.age = null;
      }
    };

    const submitForm = async () => {
      try {
        // Map the contact field to telephone
        joueur.value.telephone = joueur.value.contact;
        
        const result = await createJoueur(joueur.value);
        alert('Joueur enregistré avec succès !');
        console.log('Réponse API :', result);
        resetForm();
      } catch (error) {
        console.error('Erreur API:', error);
        alert('Erreur lors de l`enregistrement du joueur: ' + (error.response?.data?.message || error.message));
      }
    };

    const resetForm = () => {
      joueur.value = {
        ...joueur.value, // Keep the nested objects
        nom: '',
        prenom: '',
        datenaissance: '',
        age: null,
        adresse: '',
        contact: '',
        email: '',
        lieunaissance: 'Antananarivo',
        nationalite: 'Malagasy',
        taille: 0,
        poids: 0,
        photo: '',
        numeromaillot: 0,
        telephone: '',
        nompere: '',
        nommere: '',
        telparent: '',
        certificatmedical: '',
        datevaliditecertificat: '',
        numerolicence: '',
        dateinscription: new Date().toISOString().slice(0, 10)
      };
    };

    return {
      joueur,
      calculerAge,
      submitForm,
      resetForm
    };
  }
};
</script>

<template>

<SideBar/>

  <div class="form-container">
    <h1>NOUVEAU JOUEUR</h1>
    
    <form @submit.prevent="submitForm" class="player-form">
      <div class="form-row">
        <div class="form-group">
          <label for="nom">Nom*</label>
          <input 
            type="text" 
            id="nom" 
            v-model="joueur.nom" 
            required
            placeholder="Entrez le nom"
          >
        </div>
        
        <div class="form-group">
          <label for="prenom">Prénom*</label>
          <input 
            type="text" 
            id="prenom" 
            v-model="joueur.prenom" 
            required
            placeholder="Entrez le prénom"
          >
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="naissance">Date de naissance*</label>
          <input 
            type="date" 
            id="naissance" 
            v-model="joueur.datenaissance" 
            required
            @change="calculerAge"
          >
        </div>
        
        <div class="form-group">
          <label for="age">Âge</label>
          <input 
            type="number" 
            id="age" 
            v-model="joueur.age" 
            disabled
            placeholder="Calculé automatiquement"
          >
        </div>
      </div>

      <div class="form-group full-width">
        <label for="adresse">Adresse*</label>
        <input 
          type="text" 
          id="adresse" 
          v-model="joueur.adresse" 
          required
          placeholder="Entrez l'adresse complète"
        >
      </div>
      <div class="form-row">
        <div class="form-group">
          <label for="contact">Téléphone*</label>
          <input 
            type="tel" 
            id="contact" 
            v-model="joueur.contact" 
            required
            placeholder="+261 32 12 345 67"
            pattern="[+]{1}[0-9]{3} [0-9]{2} [0-9]{2} [0-9]{3} [0-9]{2}"
          >
        </div>
        
        <div class="form-group">
          <label for="email">Email</label>
          <input 
            type="email" 
            id="email" 
            v-model="joueur.email" 
            placeholder="joueur@example.com"
          >
        </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-submit">Enregistrer</button>
        <button type="button" class="btn-cancel" @click="resetForm">Annuler</button>
      </div>
    </form>
  </div>
</template>



<style scoped>
.form-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 30px;
  background-color: #f8f9fa;
  border-radius: 10px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 30px;
  font-size: 28px;
  text-transform: uppercase;
}

.player-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-group {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.form-group.full-width {
  flex: 100%;
}

label {
  margin-bottom: 8px;
  font-weight: 600;
  color: #2c3e50;
  font-size: 14px;
}

input {
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  transition: border-color 0.3s;
}

input:focus {
  border-color: #3498db;
  outline: none;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

input:disabled {
  background-color: #f0f0f0;
  color: #555;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  margin-top: 20px;
}

.btn-submit, .btn-cancel {
  padding: 12px 25px;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-submit {
  background-color: #3498db;
  color: white;
}

.btn-submit:hover {
  background-color: #2980b9;
}

.btn-cancel {
  background-color: #e74c3c;
  color: white;
}

.btn-cancel:hover {
  background-color: #c0392b;
}

@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
    gap: 20px;
  }
  
  .form-container {
    padding: 20px;
  }
  
  .form-actions {
    justify-content: center;
  }
}
</style>