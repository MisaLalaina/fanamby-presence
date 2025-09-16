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
          <li class="">
            <router-link to="/" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Registre Joueurs</span>
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
          <span>Séance</span>
        </template>
        <template #list>
          <li >
            <router-link to="/liste-seance" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Liste des séances</span>
            </router-link>
          </li>
          <li>
            <router-link to="/insertion-seance" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Insertion entrainement</span>
            </router-link>
          </li>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/presence.svg" alt="presence icon">
          <span>Presence</span>
        </template>
        <template #list>
          <li>
            <router-link to="/presence" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Liste presence</span>
            </router-link>
          </li>
          <li>
            <router-link to="/insertion-rapide" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Insertion presence</span>
            </router-link>
          </li>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/match.svg" alt="matchicon">
          <span>Match</span>
        </template>
        <template #list>
          <li>
            <router-link to="/match" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Liste match</span>
            </router-link>
          </li>
          <li>
            <router-link to="/insertion-match" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Insertion match</span>
            </router-link>
          </li>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/match.svg" alt="matchicon">
          <span>Composition</span>
        </template>
        <template #list>
          <li>
            <router-link to="/composition" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Liste composition</span>
            </router-link>
          </li>
          <li>
            <router-link to="/insertion-composition" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Insertion composition</span>
            </router-link>
          </li>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/message.svg" alt="matchicon">
          <span>Message</span>
        </template>
        <template #list>
          <li>
            <router-link to="/message" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>message</span>
            </router-link>
          </li>
        </template>

      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/dashboard.svg" alt="dashboardicon">
          <span>Dashboard</span>
        </template>
        <template #list>
          <li>
            <router-link to="/dashboard" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>Statistique</span>
            </router-link>
          </li>
          <li>
            <!-- <router-link to="/insertion-match" class="dropdown-item" active-class="active">
              <i class="fas fa-user-plus"></i>
              <span>Statistique individuel</span>
            </router-link> -->
          </li>
        </template>
      </MyDropdown>

      
    </nav>
  </aside>
</template>

<style scoped>
/* *{
  font-family:InterTight-Regular,sans-serif;
} */
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
  width: 90px;
  height: 90px;
  margin-bottom: 10px;
  
}

.nav-menu {
  flex: 1;
  padding: 20px 0;
  overflow-y: auto;
  justify-content: center;
  align-items: center;
  color: #ffff;
  scrollbar-width: 2px;
}



/* 

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
  width: 2px;
  text-align: center;
  color: #2493BF;
}

.nav-item:hover {
  background-color: #f3f5f6;
  color: #2493BF;
}

.dropdownTitle {
  display: flex;
  gap: 0.5rem;
}



.nav-item.active i {
  color: white;
} */


</style>