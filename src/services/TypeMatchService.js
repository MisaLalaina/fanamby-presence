import { fetchAllPages } from "./api"
import { BASE_URL } from "./config";
export async function  getAllTypeMathce(){
    const response = await fetchAllPages(`${BASE_URL}/typematchs`)
    if(response.returnCode != 1){
        throw Error("Failed fetching type Match")
    }
    return response.data.content;
}