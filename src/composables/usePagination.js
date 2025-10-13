import { PageData, PageRequest } from "@/models/pagination";
import { ref } from "vue";

export default function usePagination(){
    const pageData = ref(new PageData({}))
    const pageRequest = ref(new PageRequest({}))

    function getPagination() {
        return pageData.value
    }

    function setPagination(data){
        pageData.value = new PageData(data)
    }

    function nextPage(){
        const nextRequest = getPagination().next()
        if (nextRequest != null) {
            setPageRequest(nextRequest)
        }
    }

    function getPageRequest(){
        return pageRequest.value
    }

    function setPageRequest(page){
        pageRequest.value = page
    }

    function resetPagination(){
        pageRequest.value = new PageRequest({})
        pageData.value = new PageData({})
    }

    return {getPagination, setPagination, nextPage, resetPagination, getPageRequest, setPageRequest}
}