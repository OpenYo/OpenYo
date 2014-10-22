(function(){
    window.addEventListener('load', function(){
        var user = localStorage.getItem('id');
        if(!!user){
            $('#head').text('Yo ' + user + '!');
        } else {
            $('#head').html('Yo? -- Please <a href="/login/">Login</a>');
        }
    });
    $('#history').bind('click', function(){
        var token = localStorage.getItem("apiToken");
        if(token === undefined){
            $('#historyBox').append("<tr><td></td><td>ログインしてください。</td></tr>");
            return;
        }
        $.ajax({
            url: '/history/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                api_token: token
            },
            method: 'GET'
        }).done(function(data){
            $('#historyBox').empty();
            $('#historyBox').append("<tr><td>From</td><td>Time</td></tr>");
            var arr = data.result;
            for(var i=0; i < arr.length; ++i){
                $('#historyBox').append("<tr><td>" + arr[i].user + "</td><td>" + arr[i].time + "</td></tr>");
            }
        }).fail(function(xhr){
        })
    });
})();
