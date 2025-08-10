<script setup>
import Sidebar from '@/components/SideBar.vue'
</script>

<template>
  <div class="app-container">
    <Sidebar />
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<style>
.app-container {
  display: flex;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  margin-left: 250px;
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

@media (max-width: 768px) {
  .main-content {
    margin-left: 70px;
  }
}
</style>