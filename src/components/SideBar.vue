<script setup>
import MyDropdown from './MyDropdown.vue';
</script>

<template>
  <aside class="sidebar">
    <div class="logo-container">
      <img 
        src="@/assets/logo.jpg" alt="Logo" class="sidebar-logo"/>
    </div>

    <nav class="nav-menu">
      <MyDropdown>
        <template #title>
          <img src="@/assets/joueur.svg" alt="Joueurs icon">
          <span>Joueurs</span>
        </template>
        <template #list>
          <li>
            <router-link to="/" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Liste Joueurs</span>
            </router-link>
          </li>
          <li>
            <router-link to="/insertion-joueur" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Insertion Joueur</span>
            </router-link>
          </li>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/seance.svg" alt="Joueurs icon">
          <span>Seance</span>
        </template>
        <template #list>
          <li>
            <router-link to="/" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Liste seance</span>
            </router-link>
          </li>
          <li>
            <router-link to="/insertion-joueur" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Insertion seance</span>
            </router-link>
          </li>
        </template>
      </MyDropdown>
      <MyDropdown>
        
      </MyDropdown>


      <!-- <router-link  to="/" class="nav-item"active-class="active"exact>
        <i class="fas fa-list"></i>
        <span>Joueurs</span>
      </router-link>

      <router-link 
        to="/insertion-joueur" class="nav-item"active-class="active">
        <i class="fas fa-user-plus"></i>
        <span>Insertion Joueur</span>
      </router-link>
      <hr>
        <router-link 
          to="/liste-seance" 
          class="nav-item"
          active-class="active"
        >
          <i class="fas fa-calendar-check"></i>
          <span>Liste des Séances</span>
        </router-link>

        <router-link 
          to="/insertion-seance" 
          class="nav-item"
          active-class="active"
        >
          <i class="fas fa-plus-circle"></i>
          <span>Insertion Séance</span>
        </router-link>  
      <hr>
      <router-link 
        to="/presence" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-clipboard-check"></i>
        <span>Liste Présence</span>
      </router-link>

      <router-link 
        to="/insertion-presence" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-clipboard-check"></i>
        <span>Insertion Présence</span>
      </router-link>
      <router-link 
        to="/insertion-rapide" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-clipboard-check"></i>
        <span>Insertion Rapide Présence</span>
      </router-link>
      <hr>
      <router-link 
        to="/match" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-futbol"></i>
        <span>Liste Match</span>
      </router-link>
      <router-link 
        to="/insertion-match" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-futbol"></i>
        <span>Insertion Match</span>
      </router-link>
      <hr>
      <router-link 
        to="/composition" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-chess"></i>
        <span>Liste Composition</span>
      </router-link>
      <router-link 
        to="/insertion-composition" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-chess"></i>
        <span>Insertion Composition</span>
      </router-link>

      <router-link 
        to="/dashboard" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-tachometer-alt"></i>
        <span>Dashboard</span>
      </router-link>
       -->
    </nav>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  background-color:#174A7F;
  display: flex;
  flex-direction: column;
  position: fixed;
  left: 0;
  top: 0;
  z-index: 100;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  
}
.logo-container {
  padding: 15px;
  text-align: center;
  background-color: #174A7F;
  display: flex;
  flex-direction: column;
  align-items: center;
}
 .sidebar-logo {
  width: 85px;
  height: 85px;
  margin-bottom: 10px;
  
}



.nav-menu {
  flex: 1;
  padding: 20px 0;
  overflow-y: auto;
  justify-content: center;
  align-items: center;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: #2c3e50;
  text-decoration: none;
  transition: all 0.3s ease;
}

.nav-item i {
  margin-right: 10px;
  font-size: 1.1rem;
  width: 20px;
  text-align: center;
  color: #2493BF;
}

.nav-item:hover {
  background-color: #e6f7ff;
  color: #2493BF;
}

.dropdownTitle {
  display: flex;
  gap: 0.5rem;
}

/* .nav-item.active {
  background-color: #2493BF;
  color: white;
} */

.nav-item.active i {
  color: white;
}

/* hr {
  border: none;
  height: 1px;
  background-color: #ddd;
  margin: 10px 15px;
} */

/* @media (max-width: 768px) {
  .sidebar {
    width: 70px;
  }
  
  .logo-container h2,
  .nav-item span {
    display: none;
  }
  
  .nav-item {
    justify-content: center;
    padding: 15px 0;
  }
  
  .nav-item i {
    margin-right: 0;
    font-size: 1.3rem;
  } */
/* } */
</style>