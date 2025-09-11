<script>
export default {
  name: 'MyDropdown',
  data() {
    return {
      isOpen: false,
    }
  },
  methods: {
    toggleDropdown(event) {
      // Prevent the click from immediately closing the dropdown when clicking on the title
        this.isOpen = !this.isOpen;
    },
  },
}
</script>

<template>
  <div class="dropdown" :class="{ 'dropdown-open': isOpen }" @click="toggleDropdown">
    <span class="dropdownTitle">
      <slot name="title"></slot>
    </span>
    <ul class="dropdown-menu" v-show="isOpen">
      <slot name="list"></slot>
    </ul>
  </div>
</template>



<style scoped>
.dropdown {
  position: relative;
  display: inline-block;
  cursor: pointer;
  width: 100%;
}

.dropdownTitle {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  color: #fff;
  transition: all 0.2s ease;
  border-radius: 4px;
  text-align: center;
  width: 20px;
  height: 20px;
 
  
}

li:hover {
  background-color: #a9a9a9;
}

.dropdown-menu {
  padding: 0.5rem 0;
  margin-left: 1rem;
  font-size: 1rem;
  color: #212529;
  text-align: left;
  list-style: none;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid rgba(0, 0, 0, 0.15);
  border-radius: 0.25rem;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
}

/* Animation for dropdown */
.dropdown-menu {
  opacity: 0;
  transform: translateY(-10px);
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.dropdown-open .dropdown-menu {
  opacity: 1;
  transform: translateY(0);
}
</style>