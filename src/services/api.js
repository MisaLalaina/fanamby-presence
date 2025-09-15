export async function fetchUnpagined(url, options){
    const res = await fetch(url, options);
    if(!res.ok) throw new Error('Erreur de fetch')
    const data = await res.json();
    let page = data.data.page;
    while(page.totalPages > page.number +1){
        let nextRes = await fetch(`${url}?page=${page.number+1}`, options);
        let nextData = await nextRes.json();
        data.data.content = data.data.content.concat(nextData.data.content);
        page = nextData.data.page
    }
    return data;
}

export async function fetchPagined(url, options){
    const res = await fetch(url, options);
    if(!res.ok) throw new Error(`Erreur de fetch : ${url} | ${options}`)
    const data = await res.json();
    return data;
}