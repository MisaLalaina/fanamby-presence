export class PageRequest {
    page;
    size;
    constructor({page,size}){
        this.page = page || 0
        this.size = size || 10
    }

    getUrlParameters(){
        return `page=${this.page}&size=${this.size}`
    }
}

export class PageData {
    size;  
    number;
    totalElements;
    totalPages;

    constructor( {size, number, totalElements, totalPages}){
        this.size = size || 10
        this.number = number || 0
        this.totalElements = totalElements || 0
        this.totalPages = totalPages || 0
    }

    hasNext(){
        return this.number !== (this.totalPages-1)
    }

    next(){
        const hasNext = this.hasNext()
        if(hasNext){
            return new PageRequest({page:this.number+1, size:this.size})
        }
        return null
    }

    previous(){
        if(this.number == 0) return null
        return new PageRequest({page:this.number-1, size:this.size})
    }
}