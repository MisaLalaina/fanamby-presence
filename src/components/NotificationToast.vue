<template>
    <transition name="fade">
        <div 
            v-if="show" 
            :class="['toast-notification', `toast-${type}`]"
            role="alert"
        >
            {{ message }}
        </div>
    </transition>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    modelValue: {
        type: Object,
        required: true,
        default: () => ({ show: false, message: '', type: 'success' })
    }
});

// Utilisez modelValue pour l'objet de notification
const show = computed(() => props.modelValue.show);
const message = computed(() => props.modelValue.message);
const type = computed(() => props.modelValue.type);

// Note : La logique pour cacher la notification après un délai reste dans le composant parent
</script>

<style scoped>
.toast-notification {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 10px 20px;
    border-radius: 6px;
    font-size: 0.9rem;
    font-weight: 600;
    z-index: 1000;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.toast-success { background-color: #e6f7e9; color: #2ecc71; border: 1px solid #c8e6c9; }
.toast-error { background-color: #ffebee; color: #d32f2f; border: 1px solid #ffcdd2; }
.toast-warning { background-color: #fff3e0; color: #ff9800; border: 1px solid #ffe0b2; }

/* Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>