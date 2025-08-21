// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import ListeJoueurs from '@/views/ListeJoueur.vue'
import InsertionJoueur from '@/views/InsertionJoueur.vue'
import ListeSeance from '@/views/ListeSeance.vue'
import InsertionSeance from '@/views/InsertionSeance.vue'
import ListePresence from '@/views/ListePresence.vue'
import ListeMatch from '@/views/ListeMatch.vue'
import ListeComposition from '@/views/ListeComposition.vue'
import InsertionPresence from '@/views/InsertionPresence.vue'
import InsertionMatch from '@/views/InsertionMatch.vue'
import InsertionComposition from '@/views/InsertionComposition.vue'
import InsertionRapidePresence from '@/views/InsertionRapidePresence.vue'
import FeuilleMatch from '@/views/FeuilleMatch.vue'
import LoginClub from '@/views/LoginClub.vue'

const routes = [
   {
    path:'/login-club',
    name:'loginClub',
    component:LoginClub
  },
  {
    path: '/',
    name: 'liste',
    component: ListeJoueurs
  },
  {
    path: '/insertion-joueur',
    name: 'insertionJoueur',
    component: InsertionJoueur
  },
  {
    path: '/insertion-composition',
    name: 'insertionComposition',
    component: InsertionComposition
  },
  {
    path: '/liste-seance',
    name: 'listeSeance',
    component: ListeSeance
  },
  {
    path: '/insertion-seance',
    name: 'insertionSeance',
    component: InsertionSeance
  },
  {
    path:'/presence',
    name:'ListePresence',
    component:ListePresence
  },
  {
    path:'/insertion-presence',
    name:'InsertionPresence',
    component:InsertionPresence
  },
  {
    path:'/match',
    name:'listeMatch',
    component:ListeMatch
  },
  {
    path:'/insertion-match',
    name:'InsertionMatch',
    component:InsertionMatch
  },
  {
    path: '/composition',
    name:'listeComposition',
    component:ListeComposition
  },
   {
    path: '/insertion-rapide',
    name:'insertionRapidePresence',
    component:InsertionRapidePresence
  },
  {
    path: '/feuille-match/:id',
    name:'feuilleMatch',
    component:FeuilleMatch
  },
 
  
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router