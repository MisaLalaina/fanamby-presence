// api.js

// Fonction de vérification centralisée pour la réponse HTTP et le returnCode de l'API
async function handleResponse(response, url) {
    // 1. Vérification du statut HTTP (4xx, 5xx)
    if (!response.ok) {
        const errorBody = await response.json().catch(() => ({})); 
        throw new Error(`Erreur HTTP ${response.status} lors de l'appel à ${url}. Détail : ${JSON.stringify(errorBody)}`);
    }

    const data = await response.json();

    // 2. Vérification du code de retour de l'API (basé sur votre structure data.returnCode)
    if (data.returnCode !== 1) {
        throw new Error(data.message || 'Erreur inconnue de l\'API lors du traitement.');
    }
    
    return data;
}

// Fonction Générique pour le CREATE (POST)
export async function genericCreate(url, dataToSend, options = {}) {
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', ...options.headers },
            body: JSON.stringify(dataToSend),
            ...options // Permet de passer d'autres options comme 'signal' pour AbortController
        });

        const data = await handleResponse(response, url);
        // Retourne le 'data' principal de la réponse (souvent l'objet créé)
        return data.data; 

    } catch (error) {
        console.error(`Erreur lors de la création via POST à ${url}:`, error);
        throw error;
    }
}

// Fonction Générique pour l'UPDATE (PUT)
export async function genericUpdate(url, dataToSend, options = {}) {
    try {
        const response = await fetch(url, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', ...options.headers },
            body: JSON.stringify(dataToSend),
            ...options
        });

        const data = await handleResponse(response, url);
        // Retourne le 'data' principal de la réponse (souvent l'objet mis à jour)
        return data.data; 

    } catch (error) {
        console.error(`Erreur lors de la mise à jour via PUT à ${url}:`, error);
        throw error;
    }
}

// Fonction Générique pour le DELETE
// L'ID doit déjà être inclus dans l'URL (ex: ${BASE_URL}/seances/123)
export async function genericDelete(url, options = {}) {
    try {
        const response = await fetch(url, {
            method: 'DELETE',
            // Souvent, DELETE n'a pas besoin de Content-Type si pas de body
            ...options 
        });

        const data = await handleResponse(response, url);
        // Retourne le 'data' principal (souvent vide ou un message de succès)
        return data.data; 

    } catch (error) {
        console.error(`Erreur lors de la suppression via DELETE à ${url}:`, error);
        throw error;
    }
}

// Fonction Générique pour la Récupération/Recherche (GET)
// Utilisée pour GET by ID, GET paginé ou GET avec paramètres de recherche
export async function genericGet(url, options = {}) {
    try {
        const response = await fetch(url, options);

        const data = await handleResponse(response, url);
        
        // On retourne la réponse complète 'data' (pour que l'appelant puisse gérer la pagination)
        return data; 

    } catch (error) {
        console.error(`Erreur lors de la récupération via GET à ${url}:`, error);
        throw error;
    }
}

/**
 * Fonction Générique pour la Recherche ou la Récupération de données via POST avec un body.
 * @param {string} url - L'URL de l'endpoint de recherche.
 * @param {object} searchSpec - L'objet de spécification de recherche (le body).
 * @param {object} options - Options supplémentaires pour fetch.
 */
export async function genericSearch(url, searchSpec, pageRequest = null, options = {}) {
    try {
        const postOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', ...options.headers },
            body: JSON.stringify(searchSpec),
            ...options
        }

        if (pageRequest == null) {
            const response = await fetchAllPages(url, postOptions);
            return response
        }
        url = `${url}${url.includes('?') ? '&' : '?'}${pageRequest.getUrlParameters()}`;
        const response = await fetch(url, postOptions);
        const data = await handleResponse(response, url);
        return data;
    } catch (error) {
        console.error(`Erreur lors de la recherche via POST à ${url}:`, error);
        throw error;
    }
}

export async function fetchAllPages(url, options = {}) {
    const defaultPage = 0;
    let currentPage = defaultPage;
    let allContent = [];
    let totalPages = 1;

    // Déclaration d'une variable pour stocker la structure de base de la réponse
    let initialData = {}; 

    try {
        while (currentPage < totalPages) {
            
            const pageUrl = currentPage === defaultPage 
                ? url
                : `${url}${url.includes('?') ? '&' : '?'}page=${currentPage}`;

            const res = await fetch(pageUrl, options);

            const data = await handleResponse(res, pageUrl)
            
            // Si c'est le premier appel, on stocke la structure de base (pour le retour final)
            if (currentPage === defaultPage) {
                initialData = data;
            }

            // Vérification de la structure de la réponse (on utilise 'data' ici car c'est la réponse de la page en cours)
            if (!data.data || !data.data.page || !data.data.content) {
                throw new Error("Structure de réponse API inattendue pour la pagination.");
            }

            const pageData = data.data.page;
            allContent = allContent.concat(data.data.content);
            
            totalPages = pageData.totalPages;
            currentPage = pageData.number + 1;
        }

        // AMÉLIORATION : Utilisation de la variable 'initialData' définie en dehors de la boucle
        return { 
            ...initialData, // On prend toutes les propriétés de la première réponse (ex: 'data.status')
            data: { 
                ...initialData.data, // On garde toutes les autres propriétés de 'data' (sauf 'content' et 'page')
                content: allContent, 
                // Optionnel : on met à jour les métadonnées de pagination
                page: {
                    ...initialData.data.page,
                    number: 0, // On peut réinitialiser à 0 car c'est un résultat complet
                    size: allContent.length,
                    totalElements: allContent.length,
                    totalPages: 1
                }
            } 
        };

    } catch (error) {
        console.error('Erreur dans fetchAllPages:', error);
        throw error;
    }
}

