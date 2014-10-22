(function(){
    window.addEventListener('load', function(){
        var user = localStorage.getItem('id');
        if(!!user){
            $('#head').html('Yo ' + user + '! Go <a href="/mypage/">MyPage</a>');
            $('#auth').attr('disabled', true);
        } else {
            $('#head').text('Yo? -- Please Login');
        }
    });
    $('#auth').bind('click', function(){
        $.ajax({
            url: '/config/list_tokens/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                username: $('#id').val(),
                password: $('#pass').val()
            },
            method: 'GET'
        }).done(function(data){
             if(data.code == "200"){
                 $('#authMsg').html('ログイン成功です。<br>Go <a href="/mypage/">MyPage</a>');
                 localStorage.setItem('id', $('#id').val());
                 localStorage.setItem('apiToken', data.result[0]);
             } else {
                 $('#authMsg').text(data.result);
             }
        }).fail(function(xhr){
        })
    });
    $('#logout').bind('click', function(){
        localStorage.clear();
        $('#logoutMsg').text("Logged out!");
    });
})();
