/**
 * Created by christina on 1/13/17.
 */

new Clipboard('#copybtn');

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

$(function() { //shorthand document.ready function
    $('#inputs').on('submit', function(e) { //use on if jQuery 1.7+
        e.preventDefault();  //prevent form from submitting
        var values = {};
        $.each($('#inputs').serializeArray(), function(i, field) {
            values[field.name] = field.value;
        });
        var data = $("#inputs :input").serialize();
        console.log(data);

        // check for undefined fields (from older browsers)
        if (!('direction' in values) || values['direction'] == '') {
            alert('Must choose a direction');
            return;
        }
        if (!('weight' in values) || values['weight'] == '') {
            alert('Must choose a club weight');
            return;
        }
        if (!('angle' in values) || values['angle'] == '') {
            alert('Must enter a launch angle');
            return;
        }
        if (!('length' in values) || values['length'] == '') {
            alert('Must enter a club length');
            return;
        }
        if (!('strength' in values) || values['strength'] == '') {
            alert('Must enter a swing strength');
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
            x2*(getRandomArbitrary(.1,.25)*3.55*x7*x6) +
              x3*(getRandomArbitrary(.25,.4)*3.55*x7*x6) +
                x4*(getRandomArbitrary(.35,.45)*3.55*x7*x6) +
                .21*x7*x7 + 2.32*x7 + 1.91*x5 - x5*x5*.022 + 1.65*(x7-5)
            ;
        distance = Math.max(distance, getRandomArbitrary(.2,2));
        distance = Math.round (distance*100) / 100;
        $('#output').html('<p>The ball went '+distance.toString()+' yards.</p>');
        $('#results > tbody:last-child').append("<tr><td>"+
            values['direction']+"</td><td>"+values['weight']+"</td><td>"+
            values['angle']+"</td><td>"+values['length']+"</td><td>"+distance.toString()+"</td></tr>");
    });
});