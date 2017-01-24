/**
 * Created by christina on 1/13/17.
 */

new Clipboard('#copybtn');

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

// Standard Normal variate using Box-Muller transform.
function randn_bm() {
    var u = 1 - Math.random(); // Subtraction to flip [0, 1) to (0, 1].
    var v = 1 - Math.random();
    return Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
}




$(function() { //shorthand document.ready function
    // Instantiate a slider
    $("#length").slider('setValue', 34);
    $('#angle').slider('setValue', 0);
    $("#strength").slider('setValue', 1);

    $('#inputs').on('submit', function(e) { //use on if jQuery 1.7+
        e.preventDefault();  //prevent form from submitting
        var values = {};
        $.each($('#inputs').serializeArray(), function(i, field) {
            values[field.name] = field.value;
        });
        values['length'] = $("#length").slider('getValue');
        values['strength'] = $("#strength").slider('getValue');
        values['angle'] = $("#angle").slider('getValue');
        console.log(values);

        // check for undefined fields (from older browsers)
        if (!('direction' in values) || values['direction'] == '') {
            alert('Must choose a direction');
            return;
        }
        if (!('weight' in values) || values['weight'] == '') {
            alert('Must choose a club weight');
            return;
        }

        // parse values

        switch (values['direction']) {
            case 'south':
                var xs = 1;
                var xe = 0;
                var xw = 0;
                var xn = 0;
                break;
            case 'east':
                var xs = 0;
                var xe = 1;
                var xw = 0;
                var xn = 0;
                break;
            case 'west':
                var xs = 0;
                var xe = 0;
                var xw = 1;
                var xn = 0;
                break;
            default:
                var xs = 0;
                var xe = 0;
                var xw = 0;
                var xn = 1;
        }
        switch (values['weight']) {
            case 'light':
                var x2 = 1;
                var x3 = 0;
                var x4 = 0;
                break;
            case 'medium':
                var x2 = 0;
                var x3 = 1;
                var x4 = 0;
                break;
            default:
                var x2 = 0;
                var x3 = 0;
                var x4 = 1;
        }
        var x5 = parseFloat(values['angle']);
        var x6 = parseFloat(values['length'])-33;
        var x7 = parseFloat(values['strength']);
        var distance = getRandomArbitrary(0,3.5)+ //overall randomness
                //random boost or penalty by direction
            xs*getRandomArbitrary(0,3)+
            xn*getRandomArbitrary(0,4.5)+
            xw*-0.07*x5+ //minus wind boost
            xe*0.1*x5+ //plus wind boost
                // club weight gives you a random multiplier on strength
            x2*(getRandomArbitrary(.15,.2)*3.65*x7*Math.pow(x5,.5)) +
              x3*(getRandomArbitrary(.2,.35)*3.65*x7*Math.pow(x5,.5)) +
                x4*(getRandomArbitrary(.35,.45)*3.65*x7*Math.pow(x5,.5)) +
                .28*x7*x7 + 2.2*x6 + .7*x7*x6 + 2.25*x5 - x5*x5*.033 + 2.85*(x7-5)
            ;
        distance = Math.max(distance, getRandomArbitrary(.2,2)); // correct for negative distance
        var mydate = Date.today();
        //introduce daily variation
        distance = distance * 0.85 * (1.1 + 0.01*randn_bm() * .8*((mydate.getDay() % 5) + 1)); // more variation on some days than others
        distance = distance + 0.01*(mydate.getDay() % 3);// some days get a pure distance boost

        //add possibility of a flubbed shot
        if (Math.random() < .02) {
            distance = distance * getRandomArbitrary(0.08,.4);
        } else if (Math.random() < .01) {
            distance = getRandomArbitrary(0,5);
        }

        distance = Math.round (distance*100) / 100;

        //reset sliders
        $("#length").slider('setValue', 34);
        $('#angle').slider('setValue', 0);
        $("#strength").slider('setValue', 1);


        $('#output').html('<p>The ball went '+distance.toString()+' yards.</p>');
        $('#results > tbody:last-child').append("<tr><td>"+mydate.toString('yyyy-MM-dd')+"</td><td>"+
            values['direction']+"</td><td>"+values['weight']+"</td><td>"+values['length']+"</td><td>"+
            values['strength']+"</td><td>"+values['angle']+"</td><td>"+distance.toString()+"</td></tr>");
    });
});