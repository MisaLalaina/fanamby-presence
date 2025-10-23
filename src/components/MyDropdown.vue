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
  </div>
</template>



<style scoped>
.dropdown {
  position: relative;
  display: inline-block;
  cursor: pointer;
  width: 100%;
  padding-left: 1rem;
}

.dropdownTitle {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  color: #fff;
  transition: all 0.2s ease;
  border-radius: 4px;
  justify-content: left;
}

li:hover {
  background-color: #a9a9a9;
}

.dropdown-menu {
  padding: 0.5rem;
  margin: 0 2rem;
  font-size: 1rem;
  gap: 0.5rem;
  display: flex;
  flex-direction: column;
  text-align: left;
  list-style: none;
  background-color: transparent;
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

<style >
.dropdown-menu .dropdown-item,
.dropdown-menu li {
  display: block;
  width: 100%;
}
.dropdown-item {
  /* background-color: #fff; */
  padding: 6px;
  color: #fff;
  text-decoration: none;
  border-radius: 4px;
}
.dropdown-item:hover {
  background-color: #fff;
  color: black;
}

.dropdown-item.active {
  background-color: #fff;
  color: black;
}
.dropdown-menu:has(.dropdown-item.active) {
visibility: visible;
}
</style>