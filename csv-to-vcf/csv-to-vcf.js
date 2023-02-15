const fs = require('fs'),
    csv = require('csv-parser'),
    vCard = require('vcards-js'),
    inputFile = 'contacts.csv',
    outputFile = 'contacts.vcf';

    // Create a new vCard object
let outputString = undefined;

// Read the CSV file and convert each row into a vCard
fs.createReadStream(inputFile)
  .pipe(csv(['NAME','NUMBER']))
  .on('data', row => {
    card = vCard();
    card.formattedName = row['NAME'],
    card.cellPhone = row['NUMBER'];

    // Write the vCard to the output file
    outputString += card.getFormattedString();
  })
  .on('end', () => {
    fs.writeFileSync(outputFile, outputString)
    console.log('Conversion complete');
  });