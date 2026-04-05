import { LightningElement } from 'lwc';
import getSimpleResponse from '@salesforce/apex/HN_SimpleProgram.getSimpleResponse';
export default class HN_Sample_Component extends LightningElement {

apiRes;


    handelOnClick(){
    
        getSimpleResponse().then(result=>{
            this.apiRes = JSON.parse(result);   
            console.log('HN apiRes:', this.apiRes);
        }).catch(error=>{
            console.error('Apex error:', error.body?.message || error.message);
        });
    }

}