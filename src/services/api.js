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

            if (!res.ok) {
                const errorBody = await res.json().catch(() => ({})); 
                throw new Error(`Erreur HTTP ${res.status} lors du fetch de ${pageUrl}. Détail : ${JSON.stringify(errorBody)}`);
            }

            const data = await res.json();
            
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