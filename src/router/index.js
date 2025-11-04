// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import ListeJoueurs from '@/views/ListeJoueur.vue'
import InsertionJoueur from '@/views/InsertionJoueur.vue'
import ListeSeance from '@/views/ListeSeance.vue'
import InsertionSeance from '@/views/InsertionSeance.vue'
import ListePresence from '@/views/ListePresence.vue'
import ListeMatch from '@/views/ListeMatch.vue'
import ListeComposition from '@/views/ListeComposition.vue'
import InsertionComposition from '@/views/InsertionComposition.vue'
import InsertionRapidePresence from '@/views/InsertionRapidePresence.vue'
import FeuilleMatch from '@/views/FeuilleMatch.vue'
import LoginClub from '@/views/LoginClub.vue'
import Statistique from '@/views/Statistique.vue'
import MessageGroupView from '@/views/MessageGroupView.vue'
import PublicationFacebook from '@/views/PublicationFacebook.vue'
import SuiviFacebook from '@/views/SuiviFacebook.vue'
import ModificationSeance from '@/views/ModificationSeance.vue'
import UpdateJoueur from '@/views/joueur/UpdateJoueur.vue'
import JoueurProfile from '@/views/joueur/JoueurProfile.vue'
import InsertionMatchComposition from '@/views/InsertionMatchComposition.vue'
import MatchEdit from '@/views/MatchEdit.vue'
import SeancesCalendar from '@/views/SeancesCalendar.vue'
const routes = [
  {
    path:'/',
    redirect:'/dashboard'
  },
   {
    path:'/login-club',
    name:'loginClub',
    component:LoginClub
  },
  {
    path: '/joueurs',
    name: 'listeJoueur',
    component: ListeJoueurs
  },
  {
    path: '/joueurs/create',
    name: 'insertionJoueur',
    component: InsertionJoueur
  },
  {
    path: '/joueurs/:id',
    name: 'profileJoueur',
    component: JoueurProfile
  },
  {
    path: '/joueurs/update/:id',
    name: 'modificationJoueur',
    component: UpdateJoueur
  },
  {
    path: '/seances',
    name: 'listeSeance',
    component: SeancesCalendar
  },
  {
    path: '/entrainements/create',
    name: 'insertionSeance',
    component: InsertionSeance
  },
  {
    path:'/presences/:idSeance',
    name:'ListePresence',
    component:ListePresence
  },
  {
    path:'/presences/create',
    name:'insertionRapidePresence',
    component:InsertionRapidePresence
  },
  {
    path:'/matchs',
    name:'listeMatch',
    component:ListeMatch
  },
  {
    path:'/matchs/create',
    name:'InsertionMatch',
    component:InsertionMatchComposition
  },
  {
    path:'/matchs/update/:id',
    name:'UpdateMatch',
    component:MatchEdit
  },
  {
    path: '/composition',
    name:'listeComposition',
    component:ListeComposition
  },
  {
    path: '/insertion-composition',
    name: 'insertionComposition',
    component: InsertionComposition
  },
  {
    path: '/matchs/:id',
    name:'feuilleMatch',
    component:FeuilleMatch
  },
  {
    path: '/dashboard',
    name:'dashboard',
    component: Statistique
  },
  
  {
    path:'/messages',
    name:'messages',
    component: MessageGroupView
  }, 

  {
    path:'/publication',
    name:'publicationFacebook',
    component:PublicationFacebook
  },
 {
    path: '/suivi-facebook', 
    name: 'suiviFacebook',
    component: SuiviFacebook
  },
  {
    path:'/modification-Seance',
    name:'modificationSeance',
    component:ModificationSeance
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router