import { ref } from 'vue';
const DEFAULT_TIMEOUT = 4000;
const notification = ref({ 
    show: false, 
    message: '', 
    type: 'success',
    title: '', 
    subcontent: ''
});

const showNotification = (message, type = 'success', title = '', subcontent = '', timeout = DEFAULT_TIMEOUT) => {
    clearTimeout(notification.timeoutId);
    
    notification.value = { show: true, message, type, title, subcontent };
    console.log(message, ' :: ', notification.value);
    notification.timeoutId = setTimeout(() => {
        notification.value = { 
            show: false, 
            message: '', 
            type: 'success',
            title: '', 
            subcontent: ''
        };
    }, timeout);
};

export function useNotification() {
    return {
        notification, 
        showNotification 
    };
}