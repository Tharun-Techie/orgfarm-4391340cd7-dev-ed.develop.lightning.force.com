import { LightningElement, track } from 'lwc';
import getCatFact from '@salesforce/apex/CatFactController.getCatFact';
export default class PracticeComponent extends LightningElement {
        fact;
    @track name = 'Nikhil karkra';
    @track title = 'Salesforce developer';

    changeHandler(event){
        this[event.target.name] = event.target.value
    }
    
    handleIconClick() {
            
        getCatFact()
                    .then(result => {
                        console.log('123' + result);
                        console.log('   ');


                        

                        const data = JSON.parse(result);

                        console.log('parse' + JSON.parse(result));

                        console.log('parse data' + JSON.stringify(data));
                        this.fact = data.fact;
                        console.log('Cat Fact:', this.fact);
                    })
                    .catch(error => {   
                        console.error('Apex error:', error.body?.message || error.message);
                    });

    }


}