<template>
  <aside class="sidebar">
    <div class="logo-container">
      <h2>CLUB FANAMBY</h2>
    </div>

    <nav class="nav-menu">
      <router-link 
        to="/" 
        class="nav-item"
        active-class="active"
        exact
      >
        <i class="fas fa-list"></i>
        <span>Liste des Joueurs</span>
      </router-link>

      <router-link 
        to="/insertion" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-user-plus"></i>
        <span>Insertion Joueur</span>
      </router-link>

      <router-link 
        to="/seance" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-calendar-alt"></i>
        <span>Séance</span>
      </router-link>

      <router-link 
        to="/presence" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-clipboard-check"></i>
        <span>Présence</span>
      </router-link>

      <router-link 
        to="/match" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-futbol"></i>
        <span>Match</span>
      </router-link>

      <router-link 
        to="/composition" 
        class="nav-item"
        active-class="active"
      >
        <i class="fas fa-chess"></i>
        <span>Composition</span>
      </router-link>
    </nav>
  </aside>
</template>

<script setup>
// Aucune logique nécessaire pour le moment
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  background-color: #2c3e50;
  color: white;
  display: flex;
  flex-direction: column;
  position: fixed;
  left: 0;
  top: 0;
  z-index: 100;
}

.logo-container {
  padding: 20px;
  text-align: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo-container h2 {
  color: #fff;
  margin: 0;
  font-size: 1.2rem;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.nav-menu {
  flex: 1;
  padding: 20px 0;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: #b3b3b3;
  text-decoration: none;
}

.nav-item i {
  margin-right: 10px;
  font-size: 1.1rem;
  width: 20px;
  text-align: center;
}

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.nav-item.active {
  background-color: #3498db;
  color: white;
}

@media (max-width: 768px) {
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
  }
}
</style>