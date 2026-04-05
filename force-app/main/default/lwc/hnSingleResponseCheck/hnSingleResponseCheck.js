import { LightningElement, track } from 'lwc';
import processValue from '@salesforce/apex/HN_SimpleProgram.responseChecker';

export default class HnSingleResponseCheck extends LightningElement {


    @track value;
    @track result;

    
    handleChange(event) {
        this.value = event.target.value;
    }



    
    send() {
        processValue({ userInput: this.value })
            .then(res => { this.result = res; })
            .catch(() => {});
    }


}