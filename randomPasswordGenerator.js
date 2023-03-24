const symbols = ['!','@','#','$','%','^','&','*','(',')','_','-','=','+','[','{',']','}'],
    numbers = ['1','2','3','4','5','6','7','8','9','0'],
    words = ['sensitive','skate','officer','architecture','queue','shareholder','parachute','assumption','athlete','wildcard','fountain','tired','craftsman','diameter','dangerous','excitement','hierarchy','confront','clinic','doctor','redundancy','restrain','trick','occupy','rugby','pretty','relinquish','healthy','latest','father','pursuit','tradition','forecast','stitch','staff','danger','spell','earthquake','restrict','neutral','flock','panic','velvet','divorce','personality','government','humor','reflection','appropriate','redeem'];

function generatePasswords(quantity) {
    for(let i = 0; i < quantity; i++) {
        let password = '' + capitalize(words[parseInt(Math.random() * words.length)]) + capitalize(words[parseInt(Math.random() * words.length)]) + numbers[parseInt(Math.random() * numbers.length)] + numbers[parseInt(Math.random() * numbers.length)] + numbers[parseInt(Math.random() * numbers.length)] + symbols[parseInt(Math.random() * symbols.length)] + symbols[parseInt(Math.random() * symbols.length)];
        console.log(password);
    }
}

function capitalize(word) {
    return word.substring(0, 1).toUpperCase() + word.substring(1);
}

generatePasswords(3);