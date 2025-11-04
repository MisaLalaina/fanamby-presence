<template>
  <SeanceEdit 
    v-if="currentEditId"
    :seanceId="currentEditId"
    @updated="handleUpdate"
    @cancel="handleCancel"
  />

    <div class="seance-list-container" style="display: flex; gap: 20px;">
    <div class="sidebar" style="width: 320px; max-height: 80vh; overflow-y: auto; border: 1px solid #ccc; border-radius: 6px; padding: 10px;">
        <h3>Liste des séances</h3>
        <div v-if="filteredSeances.length === 0">Aucune séance trouvée.</div>
        <ul style="list-style: none; padding: 0; margin: 0;">
        <li v-for="seance in filteredSeances" :key="seance.idSeance"
            @click="selectSeance(seance)"
            :class="{ selected: seance.idSeance === selectedSeanceId }"
            style="cursor: pointer; padding: 8px; border-bottom: 1px solid #eee;">
            <div>
                <strong>{{ getTypeName(seance.idTypeSeance) }}</strong> 
                <span :class="['status-badge', 'status-' + seance.statut]">{{ seance.statut }}</span>
            </div>
            <small>{{ seance.dateSeance }} - {{ seance.heureDebut }} / {{ seance.heureFin }}</small><br/>
            <em>{{ truncateText(seance.objectif, 40) }}</em>
        </li>
        </ul>
    </div>

  <div style="flex: 1; position: relative;">
    <div class="page-header">
      <h1>Calendrier des séances</h1>
      <div>
        <router-link to="/entrainements/create" class="btn-add">
          + Ajouter un entrainement
        </router-link>
        <router-link to="/matchs/create" class="btn-add">
          + Ajouter un match
        </router-link>
        <router-link to="/presences/create" class="btn-add">
          Insertion presences
        </router-link>
      </div>

    <div class="filter-controls">
      <select v-model="filterType" @change="filterSeances" class="filter-select">
        <option value="">Tous les types</option>
        <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
          {{ type.libelle }}
        </option>
      </select>
      <input type="date" v-model="filterDate" @change="filterSeances" class="filter-input" placeholder="Filtrer par date">
    </div>
    </div>
    <FullCalendar :options="calendarOptions" ref="calendarRef" />
    <!-- popup menu -->
    <div v-if="showEventMenu" class="event-menu-modal" :style="{ position: 'absolute', top: menuPosition.y + 'px', left: menuPosition.x + 'px', zIndex: 1000 }">
      <p><strong>{{ selectedEvent.title }}</strong></p>
      <template v-if="selectedEvent.id">
        <button @click="viewEvent">Voir</button>
        <button @click="editEvent">Modifier</button>
        <button @click="deleteEvent">Supprimer</button>
      </template>
      <template v-else>
        <button @click="addEvent">Ajouter ici</button>
      </template>
      <button @click="closeMenu">Annuler</button>
    </div>
  </div>
</div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import SeanceService from '@/services/SeanceService';
import TypeSeanceService from '@/services/TypeSeanceService';
import { Seance } from '@/models/seance';
import { TypeSeance } from '@/models/typeSeance';
import SeanceEdit from './SeanceEdit.vue';
import { useRouter } from 'vue-router';
import { watch } from 'vue'

const currentEditId = ref(null)
const showEventMenu = ref(false)
const selectedEvent = ref(null)
const typesSeance = ref([]);
const seances = ref([]);
const filteredSeances = ref([]);
const menuPosition = ref({ x: 0, y: 0 });
const calendarRef = ref(null)

const filterType = ref('');
const filterDate = ref('');
const isLoading = ref(false);
const error = ref(null);

const router = useRouter();
const calendarOptions = computed(() => ({
  plugins: [dayGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth',
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,timeGridWeek,timeGridDay',
  },
  editable: true,
  selectable: true,
  selectMirror: true,
  dayMaxEvents: true,
  weekends: true,
  events: calendarEvents.value,
  dateClick: handleDateClick,
  eventClick: handleEventClick,
  eventClassNames: (arg) => {
    if (arg.event.extendedProps?.statut) {
      return ['status-' + arg.event.extendedProps.statut];
    }
    return [];
  },
}));

const selectedSeanceId = ref(null);

const selectSeance = (seance) => {
  selectedSeanceId.value = seance.idSeance;

  const calendarApi = calendarRef.value.getApi();
  calendarApi.gotoDate(seance.dateSeance);

  // Simuler un click sur l'événement correspondant pour ouvrir le menu popup
  const event = calendarApi.getEventById(seance.idSeance);
  if (event) {
    selectedEvent.value = event;
    menuPosition.value = {
        x: 100,
        y: 100,
    };

    showEventMenu.value = true;
  }
};

const fetchInitialData = async () => {
  isLoading.value = true;
  error.value = null;
  try {
    const typeSeancesData = await TypeSeanceService.getAllTypeSeances();
    typesSeance.value = TypeSeance.formatTypeSeances(typeSeancesData);

    const seancesData = await SeanceService.getAllSeances();
    seances.value = Seance.formatSeances(seancesData);
    filteredSeances.value = [...seances.value];
    filterSeances()
  } catch (err) {
    error.value = err.message || 'Erreur lors du chargement des données';
  } finally {
    isLoading.value = false;
  }
};

const filterSeances = () => {
  filteredSeances.value = seances.value.filter(seance => {
    const typeMatch = !filterType.value || seance.idTypeSeance == filterType.value;
    const dateMatch = !filterDate.value || seance.dateSeance === filterDate.value;
    return typeMatch && dateMatch;
  });
};

const getTypeName = (id) => {
  const type = typesSeance.value.find(t => t.idTypeSeance === id);
  return type ? type.libelle : 'Inconnu';
};

const truncateText = (text, length) => {
  if (!text) return '';
  return text.length > length ? text.substring(0, length) + '...' : text;
};

const calendarEvents = computed(() =>
  filteredSeances.value.map(seance => ({
    id: seance.idSeance,
    title: getTypeName(seance.idTypeSeance) + (seance.objectif ? ' - ' + truncateText(seance.objectif, 20) : ''),
    start: seance.dateSeance + 'T' + seance.heureDebut,
    end: seance.dateSeance + 'T' + seance.heureFin,
    extendedProps: {
      lieu: seance.lieu,
      statut: seance.statut,
      seance: seance,
    },
  }))
);

const handleEventClick = (clickInfo) => {
  selectedEvent.value = clickInfo.event;
  const rect = clickInfo.jsEvent.target.getBoundingClientRect();
  menuPosition.value = {
    x: rect.x - 100 ,
    y: rect.y,
  };

  showEventMenu.value = true;
};

const handleDateClick = (clickInfo) => {
  selectedEvent.value = {
    title: `Ajouter une séance le ${clickInfo.dateStr}`,
    dateStr: clickInfo.dateStr,
  };

  const rect = clickInfo.jsEvent.target.getBoundingClientRect();
  console.log(rect);
  
  menuPosition.value = {
    x: rect.x - 100 ,
    y: rect.y,
  };
  showEventMenu.value = true;
};

const handleCancel = () => {
  currentEditId.value = null;
};

const handleUpdate = () => {
  currentEditId.value = null;
  fetchInitialData();
};


const viewEvent = () => {
  showEventMenu.value = false;
  router.push({path:`/presences/${selectedEvent.value.id}`});
};

const editEvent = () => {
  showEventMenu.value = false;
  currentEditId.value = selectedEvent.value.id; // ouvre ton composant d'édition existant
};

const deleteEvent = async () => {
  showEventMenu.value = false;
  if (!confirm('Voulez-vous vraiment supprimer cette séance ?')) return;
  try {
    await SeanceService.deleteSeance(selectedEvent.value.id);
    await fetchInitialData(); // actualiser la liste
  } catch (err) {
    alert('Erreur lors de la suppression : ' + err.message);
  }
};

const closeMenu = () => {
  showEventMenu.value = false;
};

const addEvent = () => {
  showEventMenu.value = false;
  currentEditId.value = null;
  console.log(selectedEvent.value);

  router.push({
    path: '/entrainements/create',
    query: { date: selectedEvent.value.dateStr }
  });
};

// Dès que filteredSeances change, on navigue à la date du premier événement
watch(filteredSeances, (newVal) => {
  if (newVal.length > 0 && calendarRef.value) {
    const firstDate = newVal[0].dateSeance // ISO YYYY-MM-DD
    const calendarApi = calendarRef.value.getApi()
    calendarApi.gotoDate(firstDate)
  }
})

onMounted(() => {
  fetchInitialData();
});
</script>


<style>
.event-menu-modal {
  background: white;
  border: 1px solid #aaa;
  padding: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  border-radius: 4px;
  width: 180px;
}
.sidebar li.selected {
  background-color: #d3ebff;
  border-left: 4px solid #007bff;
}
.sidebar li:hover {
  background-color: #f0f8ff;
}
.status-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 12px; /* Pill shape */
  font-size: 0.8em;
  font-weight: bold;
  text-transform: uppercase;
  min-width: 80px; /* Uniform size */
  text-align: center;
}

.status-PLANIFIE {
  background-color: #f1c40f; /* Jaune */
  color: #8e44ad;
}

.status-Effectue {
  background-color: #2ecc71; /* Vert */
  color: white;
}

.status-Annule {
  background-color: #e74c3c; /* Rouge */
  color: white;
}

.status-EnCours {
  background-color: #3498db; /* Bleu */
  color: white;
}

/* Pour que dans le calendrier le texte soit lisible */
.fc-event.status-PLANIFIE {
  background-color: #f1c40f !important;
  color: #8e44ad !important;
}
.fc-event.status-Effectue {
  background-color: #2ecc71 !important;
  color: white !important;
}
.fc-event.status-Annule {
  background-color: #e74c3c !important;
  color: white !important;
}
.fc-event.status-EnCours {
  background-color: #3498db !important;
  color: white !important;
}
</style>