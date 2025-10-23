<script setup>
import MyDropdown from './MyDropdown.vue';
</script>

<template>
  <aside class="sidebar">
    <div class="logo-container">
      <img src="@/assets/logo.jpg" alt="Logo" class="sidebar-logo"/>
    </div>

    <nav class="nav-menu">
      <MyDropdown>
        <template #title>
          <img src="@/assets/dashboard.svg" class="list-icon" alt="dashboardicon">
          <router-link to="/dashboard" class="dropdown-item" active-class="active" exact>
              <i class="fas fa-list"></i>
              <span>dashboard</span>
            </router-link>
        </template>
      </MyDropdown>
      <MyDropdown>
        <template #title>
          <img src="@/assets/joueur.svg" class="list-icon" alt="Joueurs icon">
          <router-link to="/" class="dropdown-item" active-class="active" exact>
              <span>Joueurs</span>
            </router-link>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/seance.svg" class="list-icon" alt="Joueurs icon">
          <router-link to="/liste-seance" class="dropdown-item" active-class="active" exact>
              <span>Séances</span>
            </router-link>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/presence.svg" class="list-icon" alt="presence icon">
          <router-link to="/presence" class="dropdown-item" active-class="active" exact>
              <span>Presences</span>
            </router-link>
        </template>
      </MyDropdown>
      <MyDropdown>
        <template #title>
          <img src="@/assets/match.svg" class="list-icon" alt="matchicon">
          <router-link to="/match" class="dropdown-item" active-class="active" exact>
              <span>Matchs</span>
            </router-link>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/match.svg" class="list-icon" alt="matchicon">
          <router-link to="/insertion-composition" class="dropdown-item" active-class="active">
              <span>Insertion composition</span>
            </router-link>
        </template>
      </MyDropdown>
        <MyDropdown>
        <template #title>
          <img src="@/assets/message.svg" class="list-icon" alt="matchicon">
          <router-link to="/messages" class="dropdown-item" active-class="active" exact>
              <span>SMS</span>
            </router-link>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/publication.svg" class="list-icon" alt="Joueurs icon">
          <router-link to="/publication" class="dropdown-item" active-class="active" exact>
              <span>Facebook</span>
            </router-link>
        </template>
      </MyDropdown>

      <MyDropdown>
        <template #title>
          <img src="@/assets/publication.svg" class="list-icon" alt="Joueurs icon">
          <router-link to="/suivi-facebook" class="dropdown-item" active-class="active" exact>
              <span>Suivi Facebook</span>
            </router-link>
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

.list-icon{
  width: 16px;
}
</style>