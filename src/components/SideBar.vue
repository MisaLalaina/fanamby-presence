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
        to="/statistiques" 
        class="nav-item"
        active-class="active"
      >
       
      </router-link>

      <router-link 
        to="/parametres" 
        class="nav-item"
        active-class="active"
      >
       
      </router-link>
    </nav>

    <div class="sidebar-footer">
      <div class="user-profile">
        <!-- <img 
          src="https://randomuser.me/api/portraits/men/32.jpg" 
          alt="Admin"
          class="profile-img"
        > -->
        <!-- <div class="profile-info">
          <span class="username">Admin</span>
          <span class="role">Administrateur</span>
        </div> -->
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref } from 'vue';
const isCollapsed = ref(false);
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  background-color: #2c3e50;
  color: white;
  display: flex;
  flex-direction: column;
  transition: all 0.3s ease;
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
  overflow-y: auto;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: #b3b3b3;
  text-decoration: none;
  transition: all 0.3s;
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

.sidebar-footer {
  padding: 15px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.user-profile {
  display: flex;
  align-items: center;
}

.profile-img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.profile-info {
  display: flex;
  flex-direction: column;
}

.username {
  font-weight: 600;
  font-size: 0.9rem;
}

.role {
  font-size: 0.8rem;
  color: #b3b3b3;
}

/* Version réduite */
.sidebar.collapsed {
  width: 70px;
}

.sidebar.collapsed .logo-container h2,
.sidebar.collapsed .nav-item span,
.sidebar.collapsed .profile-info {
  display: none;
}

.sidebar.collapsed .nav-item {
  justify-content: center;
  padding: 15px 0;
}

.sidebar.collapsed .nav-item i {
  margin-right: 0;
  font-size: 1.3rem;
}

@media (max-width: 768px) {
  .sidebar {
    width: 70px;
  }
  
  .logo-container h2,
  .nav-item span,
  .profile-info {
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