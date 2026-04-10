import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

// Apex
import createOpportunity from '@salesforce/apex/OpportunityController.createOpportunity';
import getCarBookingOpportunities from '@salesforce/apex/OpportunityController.getCarBookingOpportunities';

// Picklist APIs
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';

export default class CreateOpportunityApex extends LightningElement {

    // ========================
    // FORM STATE
    // ========================
    oppName;
    closeDate;
    stageName;
    amount;

    // ========================
    // TABLE STATE
    // ========================
    opportunities;
    wiredOppResult;

    columns = [
        { label: 'Opportunity Name', fieldName: 'Name' },
        { label: 'Stage', fieldName: 'StageName' },
        { label: 'Amount', fieldName: 'Amount', type: 'currency' },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
    ];

    // ========================
    // PICKLIST STATE
    // ========================
    recordTypeId;
    stageOptions = [];

    // Get Opportunity metadata (record type)
    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    opportunityInfo({ data, error }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
        } else if (error) {
            this.showToast('Error', 'Failed to load Opportunity metadata', 'error');
        }
    }

    // Get StageName picklist values
    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: STAGE_FIELD
    })
    stagePicklist({ data, error }) {
        if (data) {
            this.stageOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            this.showToast('Error', 'Failed to load Booking Stages', 'error');
        }
    }

    handleNameChange(e) {
        this.oppName = e.target.value;
    }

    handleDateChange(e) {
        this.closeDate = e.target.value;
    }

    handleStageChange(e) {
        this.stageName = e.detail.value;
    }

    handleAmountChange(e) {
        this.amount = e.target.value;
    }

    handleSaveWrapper(){
        this.handleSave();

    }

    handleSave() {
        if (!this.oppName || !this.closeDate || !this.stageName) {
            this.showToast(
                'Validation Error',
                'Please fill all required fields',
                'warning'
            );
            return;
        }

        createOpportunity({
            oppName: this.oppName+this.closeDate,
            closeDate: this.closeDate,
            stageName: this.stageName,
            amount: this.amount
        })
        .then(() => {
            this.showToast(
                'Success',
                'Car booking opportunity created',
                'success'
            );
            return refreshApex(this.wiredOppResult);
        })
        .catch(error => {
            this.showToast(
                'Error',
                error?.body?.message || 'Unexpected error occurred',
                'error'
            );
        });
    }

    // ========================
    // LOAD OPPORTUNITIES
    // ========================
    @wire(getCarBookingOpportunities)
    wiredOpportunities(result) {
        this.wiredOppResult = result;

        if (result.data) {
            this.opportunities = result.data;
        } else if (result.error) {
            this.showToast('Error', 'Failed to load opportunities', 'error');
        }
    }

    // ========================
    // UTILITY
    // ======================== 
    showToast(title, message, variant) {
        console.log('Showing toast:', JSON.stringify({ title, message, variant }));
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant },'wefwefwefwef')
        );
    }
}