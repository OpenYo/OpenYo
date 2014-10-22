(function(){
    window.addEventListener('load', function(){
        var user = localStorage.getItem('id');
        if(!!user){
            $('#head').text('Yo ' + user + '!');
        } else {
            $('#head').html('Yo? -- Please <a href="/login/">Login</a>');
        }
    });
})();
