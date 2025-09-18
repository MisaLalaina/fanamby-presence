import axios from "axios";

const FB_PAGE_ID = import.meta.env.VITE_FB_PAGE_ID;
const FB_TOKEN = import.meta.env.VITE_FB_TOKEN;
const BASE_URL = import.meta.env.VITE_FB_GRAPH_URL;

export async function feed(content) {
  const url = `${BASE_URL}/${FB_PAGE_ID}/feed`;

  try {
    const response = await axios.post(
      url,
      {
        message: content,
        access_token: FB_TOKEN,
      },
      {
        headers: {
          "Content-Type": "application/json"
        },
      }
    );

    // Retourne la réponse de l'API Facebook
    return response.data;
  } catch (error) {
    console.error("Erreur lors de la publication Facebook :", error.response?.data || error.message);
    throw error;
  }
}
