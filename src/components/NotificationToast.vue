<template>
    <transition name="fade">
        <div 
            v-if="show" 
            :class="['toast-notification', `toast-${type}`]"
            role="alert"
        >
            <div class="toast-title" v-if="$slots.title || title">
                <slot name="title">
                    {{ title }}
                </slot>
            </div>
            
            <div class="toast-content" v-if="$slots.default || message">
                <slot>
                    {{ message }}
                </slot>
            </div>

            <div class="toast-subcontent" v-if="$slots.subcontent || subcontent">
                <slot name="subcontent">
                    {{ subcontent }}
                </slot>
            </div>
        </div>
    </transition>
</template>

<script setup>
import { computed, useSlots } from 'vue';

const props = defineProps({
    modelValue: {
        type: Object,
        required: true,
        default: () => ({ 
            show: false, 
            message: '', 
            type: 'success',
            title: '',
            subcontent: ''
        })
    }
});

const show = computed(() => props.modelValue.show);
const message = computed(() => props.modelValue.message);
const type = computed(() => props.modelValue.type);

const title = computed(() => props.modelValue.title);
const subcontent = computed(() => props.modelValue.subcontent);

const $slots = useSlots();
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
.toast-title {
    font-size: 1.0rem;
    font-weight: 700; /* Plus gras pour le titre */
    margin-bottom: 5px;
}

.toast-content {
    font-size: 0.9rem;
    font-weight: 500;
}

.toast-subcontent {
    font-size: 0.8rem;
    font-weight: 400;
    opacity: 0.8;
    margin-top: 5px;
}
</style>