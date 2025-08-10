// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import ListeJoueurs from '@/views/ListeJoueur.vue'
import InsertionJoueur from '@/views/InsertionJoueur.vue'
import SeanceEntrenementMatch from '@/views/SeanceEntrenementMatch.vue'

const routes = [
  {
    path: '/',
    name: 'liste',
    component: ListeJoueurs
  },
  {
    path: '/insertion',
    name: 'insertion',
    component: InsertionJoueur
  },
  {
    path: '/seance',
    name: 'SeanceEntrenementMatch',
    component: SeanceEntrenementMatch
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router