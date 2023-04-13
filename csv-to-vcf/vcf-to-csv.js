const vCard = require('vcf-parser');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const fs = require('fs');

const vcfFilePath = './vcf-source.vcf';
const csvFilePath = './csv-result.csv';

const csvWriter = createCsvWriter({
    path: csvFilePath,
    header: [
        { id: 'name', title: 'FN' },
        { id: 'organization', title: 'ORG' },
        { id: 'tel', title: 'TEL' },
    ]
});

fs.readFile(vcfFilePath, 'utf8', (err, data) => {
    if (err) throw err;
    
    const contacts = vCard.parse(data);

    const csvData = contacts.map(contact => {
        return {
            name: contact.get('fn').value,
            organization: contact.get('org').value,
            tel: contact.get('tel').value,
        };
    });

    csvWriter.writeRecords(csvData)
        .then(() => console.log('The CSV file was written successfully'));
});