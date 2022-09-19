// const output = require('./output.txt');
const fs = require('fs');
const date = new Date();
const folderName = `${date.getDate()}-${date.getMonth() + 1}`;
const fileName = `${folderName}-${date.getHours()}`;

if(!fs.existsSync(`${folderName}`))
    fs.mkdirSync(`./${folderName}`);

let cleanData = [];

// Parse raw data, removing leading spaces, commas, and
function dataCleaner() {
    // split each line into array entries
    let array = fs.readFileSync('./output.txt').toString().split('\n');

    // remove all commas
    // kill dead space in beginning
    // turn into json
    for(let i = 0; i < array.length; i++) { 
        array[i] = array[i].replace(',', '');
        let firstNumberSpot = undefined;
        for(let j = 0; j < 10; j++) {
            if(array[i].substring(j, j+1) != ' ') {
                firstNumberSpot = j;
                break;
            }
        }
        // set entry to be everything after the first number
        array[i] = array[i].substring(firstNumberSpot);

        // swap into JSON
        let size = undefined;
        let path = undefined;

        for(let j = 0; j < 10; j++) {
            if(array[i].substring(j, j+1) == ' ') {
                size = array[i].substring(0, j);
                path = array[i].substring(j + 2, array[i].length - 1);
                break;
            }
        }
        
        
        cleanData.push(
        {
            'size': size,
            'path': path
        });
    }
    let text = '';
    for(let i = 0; i < cleanData.length; i++) {
        text += `${cleanData[i].size}  ${cleanData[i].path}\n`;
    }
    fs.writeFile(`./${folderName}/clean-${fileName}.txt`, text, (err) => {
        if (err)
            console.log(err);
        else {
            console.log("File written successfully\n");
        }
        });
}

dataCleaner();
// Parse set of cleaned data, creating object tracking # of times each SIZE of a reg entry occurs
// @param {JSON} cleanedData The output dataCleaner()

function gatherOccurances(cleanedData) {
    let count = {};
    let asArray = [];
    cleanedData.forEach(element => {
        if(!(element.size in count) && element.size > 50) {
            count[element.size] = 0; 
        } 
        count[element.size]++;
    });
    asArray = Object.entries(count);
    for(let element in count) {
        asArray.push([element.key, element.value]);
    }
    asArray.sort(function(a, b) {
        return b[1] - a[1];
    });

    let text = 'Size: Count\n';
    
    for(let i = 0; i < asArray.length; i++) {
        if(!asArray[i][0] || !asArray[i][1])
            break;
        text += `${asArray[i][0]}: ${asArray[i][1]}\n`;
    }
    fs.writeFile(`./${folderName}/final-${fileName}.txt`, text, (err) => {
        if (err)
          console.log(err);
        else {
          console.log("File written successfully\n");
        }
      });
}
gatherOccurances(cleanData);