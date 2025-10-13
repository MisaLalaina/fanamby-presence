<template>
    <div class="custom-select-wrapper" v-click-outside="closeDropdown">
        <div 
            class="custom-select-display form-control" 
            tabindex="0"
            @click="isOpen = !isOpen"
            :class="{ 'open': isOpen }"
        >
            {{ selectedOptionLabel || '-- Sélectionner --' }}
        </div>
        
        <div class="custom-select-dropdown" v-if="isOpen">
            <input 
                type="text"
                v-model="searchTerm"
                class="search-input form-control"
                placeholder="Rechercher nom ou poste..."
                @input="handleSearchInput"
                @focus="handleSearchInput"
            />
            <div class="player-list">
                <div 
                    v-for="option in filteredOptions" 
                    :key="option.value"
                    class="player-option"
                    @click.stop="selectOption(option)"
                >
                    {{ option.label }}
                </div>
                <div v-if="filteredOptions.length === 0" class="no-results-search">
                    Aucun résultat.
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';

const props = defineProps({
    modelValue: { // ID du joueur actuellement sélectionné
        type: [Number, String, null],
        required: false,
    },
    options: { // Liste des joueurs disponibles [{ value: id, label: 'Nom Prénom (Poste)' }]
        type: Array,
        required: true,
        default: () => []
    },
});

const emit = defineEmits(['update:modelValue']);

const isOpen = ref(false);
const searchTerm = ref('');

// 1. Logique de Filtrage
const filteredOptions = computed(() => {
    if (!searchTerm.value) {
        return props.options;
    }
    const term = searchTerm.value.toLowerCase();
    return props.options.filter(option => 
        option.label.toLowerCase().includes(term)
    );
});

// 2. Affichage
const selectedOptionLabel = computed(() => {
    const selected = props.options.find(option => option.value === props.modelValue);
    return selected ? selected.label : null;
});

// 3. Actions
const selectOption = (option) => {
    emit('update:modelValue', option.value);
    searchTerm.value = ''; // Réinitialiser le terme de recherche
    isOpen.value = false;
};

const closeDropdown = () => {
    // Petit délai pour permettre au clic sur l'option d'être traité avant la fermeture
    setTimeout(() => {
        isOpen.value = false;
    }, 100);
};

const handleSearchInput = () => {
    isOpen.value = true;
};

// Si les options externes changent, assurez-vous que la sélection actuelle est toujours valide
watch(() => props.options, (newOptions) => {
    if (props.modelValue !== null && !newOptions.some(opt => opt.value === props.modelValue)) {
        // Si l'ID actuel n'est plus dans la liste (ex: un autre joueur l'a sélectionné)
        // On ne fait rien ici pour garder le joueur dans la ligne, mais on pourrait le déselectionner si besoin.
    }
}, { deep: true });
</script>

<style scoped>
/* Styles spécifiques au sélecteur de joueur */
.custom-select-wrapper {
    position: relative;
    width: 100%;
}

.custom-select-display {
    cursor: pointer;
    background-color: white;
    padding-right: 25px;
    min-height: 35px; /* S'assurer de la hauteur */
    display: flex;
    align-items: center;
}

.custom-select-dropdown {
    position: absolute;
    top: 100%; 
    left: 0;
    z-index: 50;
    width: 300px; /* Largeur fixe pour la lisibilité */
    max-height: 300px;
    overflow: hidden;
    border: 1px solid #ddd;
    border-radius: 4px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    background-color: white;
    margin-top: 1px;
}

.search-input {
    margin: 5px;
    width: calc(100% - 10px) !important;
}

.player-list {
    max-height: 240px;
    overflow-y: auto;
}

.player-option {
    padding: 8px 10px;
    cursor: pointer;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.player-option:hover {
    background-color: #f0f6fa;
    color: #3498db;
}

.no-results-search {
    padding: 10px;
    color: #999;
    font-style: italic;
    text-align: center;
}
</style>