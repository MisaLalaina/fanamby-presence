import axios from "axios";

const API_URL = import.meta.env.VITE_MAPI_URL;
const API_KEY = import.meta.env.VITE_MAPI_KEY;

export async function sendMessageBySMS(phone, content) {
    try {
        const formData = new FormData();
        formData.append("Recipient", phone);
        formData.append("Message", content);
        formData.append("Channel", "sms");

        console.log("Sending SMS to:", phone);
        console.log("API URL:", API_URL);
        console.log("Using token:", API_KEY ? "Token present" : "No token");

        const response = await axios.post(API_URL, formData, {
            headers: {
                Authorization: API_KEY,
            },
        });
        console.log("SMS sent successfully:", response.data);
        return response.data;
    } catch (error) {
        console.error("SMS sending failed:", error);
        throw new Error(error.response?.data?.message || error.message);
    }
}

function isValidMalagasyNumber(phone) {
  const regex = /^\+261\d{9}$/;
  return regex.test(phone);
}

export function sendMessageGroupBySMS(phones, content){
    phones.forEach( async(phone) => {
        try {
            if(!isValidMalagasyNumber(phone)){
                throw new Error(`Le numero '${phone}' est invalide`);                
            }
            const response = await sendMessageBySMS(phone, content)
            console.log(response);
        } catch (error) {
            console.error(error);
        }
    });
}

export async function sendSMS(phone, presenceDate, content) {
    const message = formatMsg(presenceDate, content);
    return await sendMessageBySMS(phone, message)    
}

function formatMsg(presenceDate, content) {
    return `${content}
Présence du ${new Date(presenceDate).toLocaleDateString("fr-FR", {
        weekday: "long",
        day: "numeric",
        month: "long",
        year: "numeric",
    })}.`;
}