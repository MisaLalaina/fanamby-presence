const HOST = import.meta.env.VITE_HOST;
const PORT = import.meta.env.VITE_PORT;
const APP_NAME = import.meta.env.VITE_APP_NAME;

export const BASE_URL = `http://${HOST}:${PORT}/${APP_NAME}`;